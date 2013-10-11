load File.expand_path("../tasks/rails.rake", __FILE__)

module Capistrano
  module Rails
    def use_bundler?
      Gem::Specification::find_all_by_name('capistrano-bundler').any?
    end
  end
end

if Capistrano::Rails.use_bundler?
  SSHKit.config.command_map[:rake] = '/usr/bin/env bundle exec rake'
end

require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
