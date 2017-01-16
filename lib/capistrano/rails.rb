require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

SSHKit.config.command_map.prefix[:rails].push('bundle exec')
