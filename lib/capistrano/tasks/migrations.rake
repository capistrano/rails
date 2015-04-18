load File.expand_path("../set_rails_env.rake", __FILE__)

namespace :deploy do

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate => [:set_rails_env] do
    on primary fetch(:migration_role) do
      conditionally_migrate = fetch(:conditionally_migrate)
      info '[deploy:migrate] Checking changes in /db/migrate' if conditionally_migrate
      if conditionally_migrate && test("diff -q #{release_path}/db/migrate #{current_path}/db/migrate")
        info '[deploy:migrate] Skip `deploy:migrate` (nothing changed in db/migrate)'
      else
        info '[deploy:migrate] Run `rake db:migrate`'
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:migrate"
          end
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate'
end

namespace :load do
  task :defaults do
    set :conditionally_migrate, fetch(:conditionally_migrate, false)
    set :migration_role, fetch(:migration_role, :db)
  end
end
