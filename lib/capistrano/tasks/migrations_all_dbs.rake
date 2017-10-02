load File.expand_path("../set_rails_env.rake", __FILE__)
require 'yaml'

namespace :deploy do

  def get_all_env
    yml_file = './config/databases.yml'
    abort "Create #{yml_file}" unless File.exists? yml_file
    envs = YAML.load_file yml_file
  end

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate_all_dbs => [:set_rails_env] do
    on fetch(:migration_servers) do
      conditionally_migrate = fetch(:conditionally_migrate)
      info '[deploy:migrate] Checking changes in db' if conditionally_migrate
      if conditionally_migrate && test(:diff, "-qr #{release_path}/db #{current_path}/db")
        info '[deploy:migrate] Skip `deploy:migrate` (nothing changed in db)'
      else
        info '[deploy:migrate] Run `rake db:migrate`'
        # NOTE: We access instance variable since the accessor was only added recently. Once capistrano-rails depends on rake 11+, we can revert the following line
        invoke :'deploy:migrating' unless Rake::Task[:'deploy:migrating'].instance_variable_get(:@already_invoked)
      end
    end
  end

  desc 'Runs rake db:migrate'
  task migrating_all_dbs: [:set_rails_env] do
    on fetch(:migration_servers) do
      within release_path do
        fetch(:all_rails_envs).each do |rails_env|
          with rails_env: rails_env.first do
            puts "Migration for #{rails_env.first} is runing"
            execute :rake, 'db:migrate'
          end
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate'
end

namespace :load do
  task :defaults do
    set :conditionally_migrate,           fetch(:conditionally_migrate, false)
    set :migration_role,                  fetch(:migration_role, :db)
    set :migration_servers, -> { primary( fetch(:migration_role)) }
    set :all_rails_envs, get_all_env
  end
end
