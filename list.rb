require 'uri'
require 'cgi'
require 'json'
require 'net/http'

fname = "urls.txt"
news_list = %w[]

File.open(fname).readlines.each do |line|
    news_list << line
end
output = File.open("output.txt", "w")
puts "file is open. parsing comments to file..."
news_list.each do |n|
    original_url = CGI::parse(n)
    sid = original_url["sid"].first
    oid = original_url["oid"].first
    aid = original_url["aid"].first
    referer_url = "http://news.naver.com/main/read.nhn?mode=LSD&mid=sec&sid1=#{sid}&oid=#{oid}&aid=#{aid}"
    comment_url = "https://apis.naver.com/commentBox/cbox5/web_naver_list_jsonp.json?ticket=news&templateId=view_it&_callback=window.__cbox_jindo_callback._1395&lang=ko&country=KR&objectId=news#{oid}%2C#{aid}&categoryId=&pageSize=10&indexSize=10&groupId=&page=1&initialize=true&useAltSort=true&replyPageSize=30&moveTo=&sort=&userType="
    
    parsed_uri = URI(comment_url)
    req = Net::HTTP::Get.new(parsed_uri)
    
    req['Referer'] = referer_url
    res = Net::HTTP.start(parsed_uri.hostname, parsed_uri.port, :use_ssl => parsed_uri.scheme == 'https'){|http|
        http.request(req)
    }
    reformed = res.body.gsub(/\r/,"").gsub(/\n/,"")[/{.+}/]
    j = JSON.parse(reformed)

    j["result"]["commentList"].each do |c| 
        output.puts "#{c['userName']}, #{c['contents']}"
    end
end
puts "comment list has been parsed to output file."

 
