class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  ##  from concerns in Model
  include CurrentCart
  before_action :set_cart
end
