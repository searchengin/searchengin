class DashboardController < ApplicationController
  # before_action :authenticate_user!
  require 'net/https'
  require 'uri'
  require 'json'

  def index
    @urls = Url.all.order("created_at DESC").paginate(page: params[:page], per_page: 15)
  end

  def get_url_object
    @url = Url.find(params[:id])
  end

  def get_domain
    domain = Domain.where("domain LIKE (?)", "#{params[:id]}%")

    if domain.present?
      domain_name = domain.first.domain
    else
      url = Url.find(params[:id])
      domain = Domain.create(domain: url.domain)
      domain_name = domain.domain
    end
    @urls = Url.where(domain: domain_name)
  end

  def search
    accessKey = ENV['BING_ACCESS_KEY']
    uri  = "https://api.cognitive.microsoft.com"
    path = "/bingcustomsearch/v7.0/search"
    custconfig = "&customconfig=484468f0-e05a-4242-9145-8374c2939e12&mkt=en-US"
    term = params[:search]
    if accessKey.length != 32 then
        puts "Invalid Bing Search API subscription key!"
        abort
    end
    uri = URI(uri + path + "?q=" + URI.escape(term)+ custconfig)
    request = Net::HTTP::Get.new(uri)
    request['Ocp-Apim-Subscription-Key'] = accessKey
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end
    response.each_header do |key, value|
        if key.start_with?("bingapis-") or key.start_with?("x-msedge-") then
            puts key + ": " + value
        end
    end
    puts "\nJSON Response:\n\n"
    @results = []
    search_results = JSON.parse(response.body)
    if search_results.present? && search_results['webPages'].present? && search_results['webPages']['value'].present?
      search_results['webPages']['value'].each do |search_result|
        @results << search_result
      end
      @results = @results.flatten
    end

    @urls_data = {}
    limit = 6
    offset = params[:page].to_i * limit
    @query = params[:search]
    connection = ActiveRecord::Base.connection
    unless params[:page]
      limit = 15
      first_tag = connection.exec_query("select t.id, t.type from tags as t
                left join where_data as where_data on where_data.where_tag_id = t.id
                left join what_data as what_data on what_data.what_tag_id = t.id
                left join when_data as when_data on when_data.when_tag_id = t.id
                left join who_data as who_data on who_data.who_tag_id = t.id
                left join why_data as why_data on why_data.why_tag_id = t.id
                where t.verified = 'true' or
                (
                  what_data.description ilike '%#{@query}%' or
                  what_data.website_url ilike '%#{@query}%' or
                  what_data.item_name ilike '%#{@query}%' or
                  where_data.location ilike '%#{@query}%' or
                  where_data.description ilike '%#{@query}%' or
                  when_data.description ilike '%#{@query}%' or
                  who_data.account ilike '%#{@query}%' or
                  who_data.description ilike '%#{@query}%' or
                  why_data.title ilike '%#{@query}%' or
                  why_data.description ilike '%#{@query}%'
                )
                order by points desc
                limit 1").first
      if first_tag
        first_tag = Tag.find(first_tag['id'])
        @urls_data[first_tag.url] = [first_tag]
      end
      urls = connection.exec_query("with query_filter as (select u.url, u.points, u.title, u.code,
            case
              when domain ilike '%#{@query}%' then 300
              when subdomain ilike '%#{@query}%' then 150
              when url ilike '%#{@query}%' then 100
              else 0
            end as extra_points,
            case
              when domain ilike '%#{@query}%' then 300 + points
              when subdomain ilike '%#{@query}%' then 150 + points
              when url ilike '%#{@query}%' then 100 + points
              else points
            end as sum_points
             from urls as u
             where url ilike '%#{@query}%' or title ilike '%#{@query}%' or description ilike '%#{@query}%'
             )
            (select u.url, u.points, u.title, u.code,  extra_points, sum_points, count(w) as inbound_links
            from query_filter as u
            left outer join what_data as w
              on u.url = w.website_url and w.category = 'External Link'
            group by u.url, u.points, u.title, u.code,  extra_points, sum_points
            order by extra_points desc, inbound_links desc, points desc
            limit 2) union all (
            select u.url, u.points, u.title, u.code, extra_points, sum_points, count(w) as inbound_links
            from query_filter as u
            left outer join what_data as w
              on u.url = w.website_url and w.category = 'External Link'
            group by u.url, u.points, u.title, u.code, extra_points, sum_points
            order by sum_points desc, inbound_links desc, points desc
          ) limit #{limit} offset #{offset}"
        )
      #urls_urls = urls.map {|url| url[:url]}
      urls_urls =  urls.rows.collect {|ind| ind[0]}
      @urls = Url.where(:url => urls_urls).all
      @urls.each do |k|
        tags =  connection.exec_query("
                select t.id, t.type from tags as t
                left join what_data as what_data on what_data.what_tag_id = t.id
                left join where_data as where_data on where_data.where_tag_id = t.id
                left join when_data as when_data on when_data.when_tag_id = t.id
                left join who_data as who_data on who_data.who_tag_id = t.id
                left join why_data as why_data on why_data.why_tag_id = t.id
                where t.url_id = #{k.id} and
                (
                  what_data.description ilike '%#{@query}%' or
                  what_data.website_url ilike '%#{@query}%' or
                  what_data.item_name ilike '%#{@query}%' or
                  where_data.location ilike '%#{@query}%' or
                  where_data.description ilike '%#{@query}%' or
                  when_data.description ilike '%#{@query}%' or
                  who_data.account ilike '%#{@query}%' or
                  who_data.description ilike '%#{@query}%' or
                  why_data.title ilike '%#{@query}%' or
                  why_data.description ilike '%#{@query}%'
                ) and
                (
                  t.verified = 'true'
                )
                order by points desc
                limit 3
              ")
            @urls_data[k] = []
            tags.each do |tag|
              tag = Tag.find(tag['id'])
              @urls_data[k].append(tag)
              #@keywords = "#{@keywords}, #{tag.meta_keyword}"
              #@description = "#{@description}, #{tag.meta_description}"
              # if [1, 3, 4].include? @user_ad_index
              #   if tag.user
              #     if tag.user.ad_client and tag.user.ad_slot
              #       @users_for_ad[@user_ad_index] = tag.user
              #     end
              #   end
              # end
            end
          end
    else
       urls = connection.exec_query("
            with query_filter as (
              select u.url, u.points, u.title, u.code, case
                  when domain ilike '%#{@query}%' then 300
                  when subdomain ilike '%#{@query}%' then 150
                  when url ilike '%#{@query}%' then 100
                  else 0
                end as extra_points,
                case
                  when domain ilike '%#{@query}%' then 300 + points
                  when subdomain ilike '%#{@query}%' then 150 + points
                  when url ilike '%#{@query}%' then 100 + points
                  else points
                end as sum_points
              from urls as u
              where url ilike '%#{@query}%' or title ilike '%#{@query}%' or description ilike '%#{@query}%'
            ) (
              select u.url, u.points, u.title, u.code, extra_points, sum_points, count(w) as inbound_links
              from query_filter as u
              left outer join what_tags as w
                on u.url = w.website_url and w.category = 'External Link'
              group by u.url, u.points, u.title, u.code, extra_points, sum_points
              order by extra_points desc, inbound_links desc, points desc
              limit 2
            ) union all (
              select u.url, u.points, u.title, u.code, extra_points, sum_points, count(w) as inbound_links
              from query_filter as u
              left outer join what_tags as w
                on u.url = w.website_url and w.category = 'External Link'
              group by u.url, u.points, u.title, u.code, extra_points, sum_points
              order by sum_points desc, inbound_links desc, points desc
            ) limit #{limit} offset #{offset}
          ")
          # tags with query
          urls_urls = urls.map {|url| url[:url]}
          urls = Url.where(:url => urls_urls).all
          urls.each_with_index do |url, index|
            # url = Url.find(url: url[:url])
            tags =  connection.exec_query("
              select t.id, t.kind, t.verified from tags as t
              left join what_data as what_data on what_data.what_tag_id = t.id
              left join where_data as where_data on where_data.where_tag_id = t.id
              left join when_data as when_data on when_data.when_tag_id = t.id
              left join who_data as who_data on who_data.who_tag_id = t.id
              left join why_data as why_data on why_data.why_tag_id = t.id
              where t.url_id = #{1} and
              (
                what_data.description ilike '%#{@query}%' or
                what_data.website_url ilike '%#{@query}%' or
                what_data.item_name ilike '%#{@query}%' or
                where_data.location ilike '%#{@query}%' or
                where_data.description ilike '%#{@query}%' or
                when_data.description ilike '%#{@query}%' or
                who_data.account ilike '%#{@query}%' or
                who_data.description ilike '%#{@query}%' or
                why_data.title ilike '%#{@query}%' or
                why_data.description ilike '%#{@query}%'
              ) and
              (
                t.verified = 'true'
              )
              order by points desc
              limit 3
            ")
            @urls_data[url] = []
            tags.all.each do |tag|
              tag = Tag.find(id: tag[:id])
              @urls_data[url].append(tag)
            end
          end
        end
      @title = "\"#{@query}\" Search Results | "
      @urls_data
  end

  def like
    if params[:tag].present?
      likes = Like.where(tag_id: params[:tag])
      if likes.count > 0
        likes.each do |like|
          if like.user_id == current_user.id
            like.delete
          end
        end
      else
        dislikes = Dislike.where(tag_id: params[:tag])
        if dislikes.count > 0
          dislikes.each do | dislike |
            if dislike.user_id == current_user.id
              dislike.delete
            end
          end
        end
        like = Like.create(user_id: current_user.id, tag_id: params[:tag])
      end
      @like_count =  Like.where(tag_id: params[:tag]).count
    else
      likes = Like.where(url_id: params[:url])
      if likes.count > 0
        likes.each do |like|
          if like.user_id == current_user.id
            like.delete
          end
        end
      else
        dislikes = Dislike.where(url_id: params[:url])
        if dislikes.count > 0
          dislikes.each do | dislike |
            if dislike.user_id == current_user.id
              dislike.delete
            end
          end
        end
        like = Like.create(user_id: current_user.id, url_id: params[:url])
      end
      @like_count =  Like.where(url_id: params[:url]).count
    end
  end

  def dislike
    if params[:tag].present?
       dislikes = Dislike.where(tag_id: params[:tag])
      if dislikes.count > 0
        dislikes.each do |dislike|
          if dislike.user_id == current_user.id
            dislike.delete
          end
        end
      else
        likes = Like.where(tag_id: params[:tag])
        if likes.count > 0
          likes.each do | like |
            if like.user_id == current_user.id
              like.delete
            end
          end
        end
       dislike = Dislike.create(user_id: current_user.id,tag_id: params[:tag])
      end
        @dislike_count = Dislike.where(url_id: params[:url]).count
    else
      dislikes = Dislike.where(url_id: params[:url])
      if dislikes.count > 0
        dislikes.each do |dislike|
          if dislike.user_id == current_user.id
            dislike.delete
          end
        end
      else
        likes = Like.where(url_id: params[:url])
        if likes.count > 0
          likes.each do | like |
            if like.user_id == current_user.id
              like.delete
            end
          end
        end
       dislike = Dislike.create(user_id: current_user.id, url_id: params[:url])
      end
        @dislike_count = Dislike.where(url_id: params[:url]).count
    end
  end


  def verify_domain
    url = Url.find(params[:id])
    domain = url.domain
    verified = DomainService.new(domain).call
    if verified
      flash[:success] = 'Site verified!'
       redirect_to profile_path(domain)
    else
      flash[:Error] = 'Site verification failed!'
       redirect_to profile_path(domain)
    end
  end
end
