namespace :deploy do

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate do
    on primary :db do
      within release_path do
        execute :rake, "db:migrate RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  after 'deploy:update', 'deploy:migrate'
end

