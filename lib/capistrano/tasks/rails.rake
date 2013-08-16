namespace :deploy do
  before :starting, :set_rails_env_and_root do
    set :rails_root, release_path
    set :rails_env, (fetch(:rails_env) || fetch(:stage))
  end
end
