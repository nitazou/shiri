#app.rb
require "rubygems"
require "sinatra"

# リロードに必要な設定
set :environment, :development
require "sinatra/base"

# マッピング
get "/" do
  "Hello world!うぉぉぉぉわえｒくぇｒｑｒ"
end