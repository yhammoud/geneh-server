class ApiController < ApplicationController
  require 'money'
  require 'monetize'
  require 'money/bank/google_currency'

  def get_exchange_rate
    Money.default_bank = Money::Bank::GoogleCurrency.new
    dollar = 1.to_money(:USD)
    geneh = dollar.exchange_to(:EGP).to_f
    render json: geneh
  end
end
