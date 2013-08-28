namespace :deploy do
  before :starting, :set_rails_env do
    set :rails_env, (fetch(:rails_env) || fetch(:stage))
  end
end
