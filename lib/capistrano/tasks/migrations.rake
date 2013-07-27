namespace :deploy do

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate do
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, "db:migrate"
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate'
end

