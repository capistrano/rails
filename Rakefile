require "bundler/gem_tasks"

# Do nothing by default
task :default

Rake::Task["release"].enhance do
  puts "Don't forget to publish the release on GitHub!"
  system "open https://github.com/capistrano/rails/releases"
end
