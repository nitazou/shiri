# coding: utf-8
require "rubygems"
require "sinatra"
require './syori/shiritori.rb'
output=Shiritori.new
 
get "/" do
  html :aa
end

get '/shiritori_process' do

 $input_key=params['key']
 return output.syori
 
end


def html(view)
  File.read(File.join('public', "#{view.to_s}.html"))
end

