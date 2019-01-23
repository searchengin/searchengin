class DashboardController < ApplicationController
  # before_action :authenticate_user!
# include Dnsruby


  def index
    @urls = Url.all.order("created_at DESC")
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
                  t.verified = 'false'
                )
                order by points desc
                limit 3
              ")
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
                t.verified = 'false'
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
    #like = Like.where(user_id: current_user.id, url_id: params[:url])
    likes = Like.where(url_id: params[:url])
    if likes.count > 0
      likes.each do |like|
        if like.user_id == current_user.id
          like.delete
        end
      end
    else
      like = Like.create(user_id: current_user.id, url_id: params[:url])
    end
    @like_count =  Like.where(url_id: params[:url]).count
  end

  def dislike
    dislikes = Dislike.where(url_id: params[:url])
    if dislikes.count > 0
      dislikes.each do |dislike|
        if dislike.user_id == current_user.id
          dislike.delete
        end
      end
    else
     dislike = Dislike.create(user_id: current_user.id, url_id: params[:url])
    end
      @dislike_count = Dislike.where(url_id: params[:url]).count
  end


  # def verify_domain
  #   #username = params[:username]
  #   #user = User.find(username: @username)

  #   url = Url.find(params[:id])
  #   domain = url.domain
  #   #mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
  #   #res = Resolver.new
  #   #ret = res.query(url)
  #   res = Dnsruby::Resolver.new
  #   ret = res.query(domain, Types.TXT)
  #   p ret.answer

  #   Dnsruby::DNS.open {|dns|
  #     dns.each_resource(domain, Types.A) {|r| p r}
  #   }
  # end

end
