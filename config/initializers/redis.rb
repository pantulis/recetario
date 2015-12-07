# -*- coding: utf-8 -*-

if ENV['REDISCLOUD_URL']
  $redis = Redis.new(url: ENV['REDISCLOUD_URL'])
  Resque.redis = $redis
end
