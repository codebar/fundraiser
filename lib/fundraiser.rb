require 'sinatra/base'
require 'stripe'

module Fundraiser
  class App < Sinatra::Base
    set :publishable_key, ENV['PUBLISHABLE_KEY']
    set :secret_key, ENV['SECRET_KEY']
    set :views, "#{Dir.pwd}/views"
    set :public_folder, "#{Dir.pwd}/public"

    Stripe.api_key = settings.secret_key

    get '/' do
      erb :index
    end

    post '/charge' do
      @amount = params[:amount]

      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :card  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :amount      => @amount,
        :description => 'Codebar Donation',
        :currency    => 'gbp',
        :customer    => customer.id
      )

      erb :charge

    end

    error Stripe::CardError do
      env['sinatra.error'].message
    end
  end
end
