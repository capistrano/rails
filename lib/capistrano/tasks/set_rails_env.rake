namespace :deploy do
  task :set_rails_env do
    set :rails_env, (fetch(:rails_env) || fetch(:stage))
  end

  task :set_rails_path do
    set :rails_path, release_path.join(fetch(:rails_path, ''))
    set :current_rails_path, current_path.join(fetch(:rails_path, ''))
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'deploy:set_rails_env'
end

after 'deploy:updated', 'deploy:set_rails_path'