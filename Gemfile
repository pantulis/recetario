# encoding: utf-8

source 'https://rubygems.org'

# para Heroku
ruby '2.2.1' 

gem 'rails', '4.2.4'

gem 'pg'
gem 'acts_as_list'
gem 'inherited_resources'
gem 'stringex'
gem 'figaro'
gem 'httparty'
# gem 'json'
# gem 'multi_json'
# gem 'activesupport-json_encoder'
gem 'wunderlist-api', github:  'pantulis/wunderlist-api'

gem 'resque'

group :production do
  gem 'rails_12factor'
  gem 'puma'
end

group :development do
  gem 'byebug'
  gem 'bullet'
  gem 'rubocop', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.0.1'
