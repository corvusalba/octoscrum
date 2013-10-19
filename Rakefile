require 'rubygems'
require 'bundler'

task :bundler do
  sh 'bundle install'
end

task :default => [:bundler] do
  conf = File.expand_path('config.ru', File.dirname(__FILE__))
  thinconf = File.expand_path('config/thinconfig.yml', File.dirname(__FILE__))
  `thin -C #{thinconf} -R #{conf} -p 8080 restart -d`
end

task :start do
  conf = File.expand_path('config.ru', File.dirname(__FILE__))
  thinconf = File.expand_path('config/thinconfig.yml', File.dirname(__FILE__))
  `thin -e development -C #{thinconf} -R #{conf} -p 8080 --debug start`
end
