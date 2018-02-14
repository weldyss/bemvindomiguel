require 'sinatra'
require 'pagseguro'
require 'securerandom'
require 'sinatra/activerecord'
require './helpers'

I18n.enforce_available_locales = false

set :public_folder, 'public'

get '/' do
  erb :index
end

get '/preorder' do
  erb :preorder
end

post '/pay' do
  order = SecureRandom.uuid
  PagSeguro.configure do |config|
    config.token       = "EC2C873997EF4D0789438EF5ECB67138"
    config.email       = "weldyss@gmail.com"
    config.environment = :production # ou :sandbox. O padrão é production.
    config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
  end

  @order = Order.new(params[:order])
  if @order.save
    payment = PagSeguro::PaymentRequest.new
    payment.reference = @order.id
    payment.sender = {
      name: @order.name,
      email: @order.email
    }
    payment.items << {
        id: @order.id,
        description: "Compra do Kit Fraldas no valor de R$ #{@order.amount}",
        amount: @order.amount.to_f,
        weight: '0'
    }
    response = payment.register
    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect response.url
    end
  else
    erb :preorder
  end
end

get '/view-messages' do
  @orders = Order.all
  erb :view_messages
end


class Order < ActiveRecord::Base
  validates :name, :email, presence: true
end