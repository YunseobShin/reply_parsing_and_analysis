require 'nokogiri'
require 'set'

fname = "urls.txt"
f = File.open(fname, "w")
url_lsit = []
puts "file is open. parsing data to file..."

1.step(ARGV[0].to_i, 1) do |i|
    doc = Nokogiri::HTML(open("results/result_#{i}.html"))
    doc.css("._sp_each_url").each do |x|
         url_lsit << x.attr("href") if x.attr("href").include?("naver.com") 
    end
end
url_set = url_lsit.to_set
url_set.each do |url|
    f.puts url
end
puts "urls have been written in text file"
