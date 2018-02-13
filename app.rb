require 'sinatra'

set :public_folder, 'public'

get '/' do
  erb :index
end

post '/pay/:value' do
  PagSeguro.configure do |config|
    config.token       = "EC2C873997EF4D0789438EF5ECB67138"
    config.email       = "weldyss@gmail.com"
    config.environment = :production # ou :sandbox. O padrão é production.
    config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
  end

  payment = PagSeguro::PaymentRequest.new(email: 'weldyss@gmail.com', token: 'EC2C873997EF4D0789438EF5ECB67138')
end
