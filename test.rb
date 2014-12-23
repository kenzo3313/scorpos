require 'open-uri'
require 'nokogiri'
require "pg"

def getItemName(node)
  return node.xpath('td[@class="end checkItem"]/table/tr/td[@class="ckitemLink"]/a[@class="ckitanker"]'  ).text
end

def getMainInfo(node)
  price ="0"
  cpu = "name"

  #puts node.xpath('td[@class="td-price"]/ul/li[@class="pryen"]').text
  price = node.xpath('td[@class="td-price"]/ul/li[@class="pryen"]').text
  price = price.delete(",¥")
  node.xpath('td').each_with_index do |column,i|
    if i == 8 then
    #  puts colmn.text
    cpu = column.text
    end
  end
  return price,cpu
end


conn = PG::Connection.open(:dbname => 'pgdbtest')
q    = "select * from notePC"
res  = conn.exec(q)
res.each do |r|
  p r
end


# スクレイピング先のURL
url = ARGV[0]
charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end
#1
# htmlをパース(解析)してオブジェクトを作成
doc = Nokogiri::HTML.parse(html, nil, charset)

#tr-border[0] 商品名
#tr-border[1] td
#tr-border[2] ckitemSpec

count = 0
name = "noname"
array = [0,"cpu"]
doc.xpath('//tr[@class="tr-border"]').each_with_index do |node,i|
  # node.xpath("td").each do |tex|
  #   puts tex.text
  # end
  if i == 0 then #最初はカラム名なので飛ばす
    next
  elsif count == 0 then
    name = getItemName(node)

    #conn.exec(q)
    count+=1
  elsif count == 1 then
      #製品名 1,4,7,10 (1+3iのIDが製品名ノード)
    array = getMainInfo(node)
    #メイン情報　(1+3i+1 がメイン情報ノード)
    count+=1
  elsif count == 2 then
      q = "insert into notePC (name,price) values(\'" + name + "\', " + array[0] + ")"
      p q
      conn.exec(q)
      count = 0
  end

  if i == 15 then
    break
  end
  puts i
end
