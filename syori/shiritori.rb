# coding: utf-8
require 'mechanize'
require "rexml/document"

class Shiritori
	def syori
		#最終結果
		@result=""
		
		#ユーザーが設定した値を初期値として設定
		@yomi_keyword=$input_key
		@yomi_keyword_result="かんじ"
		
		@suggest_q="あ"
		@suggest_hairetu=[]
		
		@agent = Mechanize.new
		
		#初期設定
		#初期値を最終結果変数に格納
		ini_result_make
		#事前チェック
		if jizen_chk==1 then
			return @result
		end
	 	
	 	
		20.times{|n| 
			#サジェスト一文字設定
			last_word_suggest_set
			puts @suggest_q
			puts n
 			#サジェスト取得
			google_suggest
			
			#サジェスト取得失敗か
			if @suggest_hairetu.size==0 then
				#ギブアップ
				@yomi_keyword="ギブアップ1"
				
				#最終結果変数に格納
				result_make
				return @result
			else
				#過去出てないかチェック
				if kako_chk==1 then
					#有効候補なし
					#ギブアップ
					@yomi_keyword="ギブアップ2"
					
					#最終結果変数に格納
					result_make
					return @result
				else
					#有効候補あり
					#事前チェック
					
					keyword_chg
					
					if jizen_chk==1 then
						#最終結果変数に格納
						result_make
						return @result
					end
				end
			end
			
			#最終結果変数に格納
		 	result_make
			#puts "result="+@result
			
		 }
		return @result
		
	end
	
	def keyword_chg
		@yomi_keyword=@suggest_hairetu[@random]
	end
	
	def kako_chk
		#最終結果の中にサジェスト候補があるか
		@random=rand(10)
		if @result.index(@suggest_hairetu[@random])==nil then
		#候補が過去に出ていない場合
			return 0
		else
		#候補が過去に出てる場合
			return 1
		end
	end
	
	def last_word_suggest_set
		@suggest_q=@yomi_keyword_result[@yomi_keyword_result.length-1]
		#puts "suggest_q="+@suggest_q
	end
	
	def result_make
		 @result<<","
		 @result<<@yomi_keyword
	end
	
	def ini_result_make
		@result<<$input_key
	end
	
	def jizen_chk
		#読みを取得
	 	yomi_yahooapi
	 	#音引き削除
	 	onbiki_del
	 	#んチェック
	 	end_check=nnchk
	 	return end_check
	end
	
	
	def yomi_yahooapi
		#puts "yomi_keyword="+@yomi_keyword
		@agent.get('http://jlp.yahooapis.jp/MAService/V1/parse?appid=dj0zaiZpPWRrcE01a0VQd0xOVSZkPVlXazlTRE5EZUVOa04yY21jR285TUEtLSZzPWNvbnN1bWVyc2VjcmV0Jng9ODA-&results=ma,uniq&uniq_filter=9%7C10&sentence=' + @yomi_keyword)
		@yomi_keyword_result=@agent.page.search('reading').inner_text#.tosjis
		#puts "yomi_keyword_result="+@yomi_keyword_result
	end
	
	def google_suggest
		#配列クリア
		@suggest_hairetu.clear 
		#googleから候補をXMLで取得
		suggest=@agent.get('http://google.co.jp/complete/search?output=toolbar&hl=ja&q=' + @suggest_q)
		#puts suggest.body.toutf8

		#XMLを解析する準備
		source=suggest.body.toutf8
		doc = REXML::Document.new source
		#puts doc

		#XMLパースし、読み仮名を取得
		doc.elements.each('toplevel/CompleteSuggestion/suggestion') do |element|
			#p element.attributes["data"]
			@suggest_hairetu <<  element.attributes["data"]
		end
		#puts @suggest_hairetu
	end
	
	def onbiki_del
		@yomi_keyword_result.slice! "ー"
		@yomi_keyword_result.slice! "ー"
		@yomi_keyword_result.slice! "-"
	end
	
	def nnchk
		if @yomi_keyword_result[@yomi_keyword_result.length-1]=="ん"
 			return 1
		else
 			return 0
 	end
 	
 end
 
end


