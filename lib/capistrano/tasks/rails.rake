namespace :load do
  task :defaults do
    set :rails_root, -> { release_path }
    set :rails_env, -> { fetch(:stage) }
  end
end