require 'open-uri'
require 'nokogiri'


def getItemName(node)
  puts node.xpath('td[@class="end checkItem"]/table/tr/td[@class="ckitemLink"]/a[@class="ckitanker"]'  ).text
end

def getMainInfo(node)
  #puts node.xpath('td[@class="td-price"]/ul/li[@class="pryen"]').text
  node.xpath('td')[7] do |colmn|
    puts colmn.text
  end
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

#2
# doc.xpath('//a[@class="ckitanker"]').each do |node|
#   #商品名取得
#   p node.text
#   name = node.text
# end

#tr-border[0] 商品名
#tr-border[1] td
#tr-border[2] ckitemSpec


doc.xpath('//tr[@class="tr-border"]').each_with_index do |node,i|
  # node.xpath("td").each do |tex|
  #   puts tex.text
  # end
  if i == 0 then #最初はカラム名なので飛ばす
    next
  end
  if i == 15 then
    break
  end
  puts i
  #製品名 1,4,7,10 (1+3iのIDが製品名ノード)
#  getItemName(node)
  #メイン情報　(1+3i+1 がメイン情報ノード)
  getMainInfo(node)
end


# ##ループの行が長くなるので代入
# trs = mainNode.css('tr > td > table > tr > td > table > tr')
# #抽出後のデータ格納
# ##畳み込みで、求めているハッシュを返す
# ##hashは畳み込みの値を保持する変数（ハッシュ）
# cashHash = trs.inject({}) do |hash, tr|
#   ##tr.textが空文字列であれば次のループへ
#   ##injectの畳み込みの値hashを返さないとエラー
#   next hash if tr.text.empty?
#   ##mapで配列を返す
#   dataAry = tr.css('td').map do |td|
#     #データ配列に追加
#     ##gsubを一つにまとめた
#     data = td.text.gsub(/[\u00A0\n]/, '').strip
#   end
#   ##暫定的にdataAry[0]に突っ込んでいたkeyNmを取り出す
#   keyNm = dataAry.shift
#   #ハッシュに追加後にキー番号で取り出し
#   hash[keyNm] = dataAry
#   ##injectの畳み込みの値hashを返さないとエラー
#   hash
# end
#
# #データ確認
# ##pメソッドはテスト出力用なのでputsにしたい
# cashHash.each do |key, value|
#   p "---------------------"
#   p key
#   p "---------------------"
#   value.each do |data|
#     p data
#   end
# end
