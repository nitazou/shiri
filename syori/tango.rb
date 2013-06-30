# coding: utf-8
require 'mechanize'
class Tango
	def get
		agent = Mechanize.new
		agent.get('http://searchranking.yahoo.co.jp/realtime_buzz/')

		tango1=[]
		i=0

		agent.page.search('li')[0..40].each do |p|
  			tango1<< p.inner_text#.tosjis
  			i=i+1
		end

		return tango1[rand(40)]
	end
end
