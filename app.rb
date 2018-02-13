require 'sinatra'
require 'securerandom'
require './helpers'

I18n.enforce_available_locales = false

set :public_folder, 'public'

get '/' do
  erb :index
end

get '/pay/:value' do
  order = SecureRandom.uuid
  PagSeguro.configure do |config|
    config.token       = "EC2C873997EF4D0789438EF5ECB67138"
    config.email       = "weldyss@gmail.com"
    config.environment = :production # ou :sandbox. O padrão é production.
    config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
  end

  payment = PagSeguro::PaymentRequest.new
  payment.reference = order
  payment.items << {
      id: params[:value].to_i,
      description: "Compra do Kit Fraldas no valor de R$ #{params[:value]}",
      amount: params[:value].to_f,
      weight: '0'
  }
  response = payment.register
  if response.errors.any?
    raise response.errors.join("\n")
  else
    redirect response.url
  end
end
