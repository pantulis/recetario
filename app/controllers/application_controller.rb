# encoding: utf-8
# We force HTTP Auth authentication if production
# as we dont have proper user management at this time

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env == 'production'
    http_basic_authenticate_with name: ENV['HTTP_AUTH_NAME'],
                                 password: ENV['HTTP_AUTH_PASSWORD']
  end
end
