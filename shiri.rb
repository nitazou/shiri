# coding: utf-8
require "rubygems"
require "sinatra/base"
require './syori/shiritori.rb'




class MyApp < Sinatra::Base


get "/" do
  html :aa
end

get '/shiritori_process' do
output=Shiritori.new
 $input_key=params['key']
 return output.syori
 
end

get '/shiritori_tango' do
require './syori/tango.rb'
set_key=Tango.new
return set_key.get
end

def html(view)
  File.read(File.join('public', "#{view.to_s}.html"))
end
end


MyApp.run! :host => 'localhost', :port => 4567
