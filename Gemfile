# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.5.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap-sass"
gem "cancancan"
gem "carrierwave", "1.2.2"
gem "chartkick"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "faker"
gem "figaro"
gem "groupdate"
gem "i18n-js"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kaminari", git: "https://github.com/kaminari/kaminari"
gem "mini_magick", "~> 4.8"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "nested_form_fields"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.3"
gem "rails-i18n"
gem "rubocop", "~> 0.54.0", require: false
gem "rufus-scheduler"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
# gem "will_paginate"
# gem "capistrano-rails", group: :development
# gem "redis", "~> 4.0"
# gem "mini_racer", platforms: :ruby

group :development, :test do
  gem "byebug", platforms: %i(mri mingw x64_mingw)
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "chromedriver-helper"
  gem "database_cleaner"
  gem "minitest", "5.11.3"
  gem "minitest-reporters", "1.1.14"
  gem "rails-controller-testing", "1.0.2"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end

group :production do
  gem "pg", "0.20.0"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
