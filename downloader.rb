k = 1
1.step(ARGV[1].to_i*10, 10) do |i|
  puts k
  `curl -o results/result_#{k}.html "https://search.naver.com/search.naver?ie=utf8&where=news&query=#{ARGV[0]}&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&mynews=0&start=#{i}&refresh_start=0"`
  k = k + 1
end
