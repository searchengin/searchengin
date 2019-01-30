class DomainService
  include Dnsruby

  def initialize name
    @name = name
  end

  def call
     #mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    # #res = Resolver.new
    # #ret = res.query(url)
    res = Dnsruby::Resolver.new
    ret = res.query(@name , Types.TXT)
    #ret.answer.first.strings
    verified = ret != nil && ret.answer.first.name.to_s == @name if ret.answer.first.present?
    return verified
  end
end
