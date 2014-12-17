require 'open-uri'
require 'nokogiri'

# スクレイピング先のURL
url = ARGV[0]

##個人的にはここまでしっかり前処理しなくてもいいのではと感じる
##  doc = Nokogiri::HTML.parse(open(url))
##で問題なし
charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを作成
doc = Nokogiri::HTML.parse(html, nil, charset)
##xpathかcssか明確にすると良いかと
mainNode = doc.css("table#yfncsumtab")
p mainNode
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
