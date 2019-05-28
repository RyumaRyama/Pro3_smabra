require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'socket'

require './models/data_init'

begin
  client = PG::connect(
    host: ENV['POSTGRES_HOST'],
    user: ENV['POSTGRES_USER'],
    password: ENV['POSTGRES_PASSWORD'],
    port: '5432',
    dbname: ENV['POSTGRES_NAME']
  )
rescue
  sleep 1
  retry
end

# 一度だけ実行されるらしい
configure do
  init_db(client)
  insert_fighters(client)
end

get '/' do
  # '\ｱｯｶﾘ~ﾝ/ '*100
  # client.exec("INSERT INTO users (name) SELECT '\\ｱｯｶﾘ~ﾝ/';")
  # fuga = ''
  # client.query('SELECT * FROM users').each do |hoge|
  #   fuga += hoge['name'] + " "
  # end
  # fuga
  # client.exec("INSERT INTO fighters (name) SELECT 'ｱｯｶﾘ~ﾝ';")
  # fuga = ''
  @fighters = {}
  client.query('SELECT * FROM fighters').each do |hoge|
    @fighters[hoge['id']] = hoge["name"]
    # fuga += "<p>" + hoge['id'] + ": " + hoge['name'] + " " + "</p>"
    #fuga += "<p>" + hoge['id'] + ": " + hoge['name'] + " " + "</p>"
    #fuga += "<p>" + @fighters[:hoge['id']] + "</p>"
    #fuga += "<p>" + @fighters['1'] + "</p>"
  end
  # fuga
  erb :top
end

get '/hello' do
  'This is a new contents.'
end

get "/gorakubu/akari" do
  '\ｱｯｶﾘ~ﾝ/ '*1000
end

get "/gorakubu/kyoko" do
  '\ｷｭｯﾋﾟ~ﾝ/ '*1000
end

get "/gorakubu/yui" do
  '\ｵｲｺﾗ/ '*1000
end

get "/gorakubu/chinatsu" do
  '\ｾﾝﾊﾟ~ｲ/ '*1000
end

get "/gorakubu" do
  @users = ["akari", "kyoko", "yui", "chinatsu"]
  erb :gorakubu
end

get "/:fighter_id" do
  fighter = client.exec("SELECT name FROM fighters WHERE id = #{params[:fighter_id]}")[0]["name"]
  fighter.to_s * 100
end
