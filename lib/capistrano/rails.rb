def use_bundler?
  Gem::Specification::find_all_by_name('capistrano-bundler').any?
end

def execute_bundled(command, *args)
  if use_bundler?
    execute :bundle, "exec", command.to_s, args
  else
    execute command, args
  end
end

load File.expand_path("../tasks/rails.rake", __FILE__)

require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
