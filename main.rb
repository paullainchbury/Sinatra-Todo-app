require 'sinatra'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require 'pg'

# read, create, update, delete, list

get '/' do

  @items = run_sql("SELECT * FROM items")
  erb :home

end

get '/new' do
  erb :new
end


get '/edit/:id' do
  @item = run_sql("SELECT * FROM items WHERE id = #{params[:id]}")
    @item = @item.first
  erb :edit
end

  get '/show/:id' do
    @item = run_sql("SELECT * FROM items WHERE id = #{params[:id]}")
    @item = @item.first

  erb :show
  end

post '/update/:id' do
  item = params[:item]
  details = params[:details]

  run_sql("UPDATE items SET item='#{item}', details='#{details}' WHERE id='#{params[:id]}'")

  redirect to "/show/#{params[:id]}"
end



post '/create' do
  item = params[:item]
  details = params[:details]

  run_sql("INSERT into items (item, details) VALUES ('#{item}', '#{details}')")

  redirect to '/'
end

post '/delete/:id' do
  
  run_sql("DELETE from items where id='#{params[:id]}'")
  redirect to '/'
end

get '/video' do
  erb :video
end


def run_sql(statement)
  
  conn = PG.connect(dbname: 'todo', host: 'localhost')
  begin
      result = conn.exec(statement)
    ensure
      conn.close
  end
  result
end




