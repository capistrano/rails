load File.expand_path("../set_rails_env.rake", __FILE__)
require 'yaml'
require 'byebug'

namespace :deploy do
  def get_all_env
    yml_file = '/home/deploy/v2ror_devel/config/database.yml'
    on roles :all do |host|
      abort "Create #{yml_file}" unless test("[ -f #{yml_file} ]")
    end
      envs = YAML.load(`ssh devel "cat #{yml_file}"`)
  end

  desc 'Runs rake db:migrate_all_dbs if migrations are set'
  task :migrate_all_dbs => [:set_rails_env] do
    on fetch(:migration_servers) do
      conditionally_migrate = fetch(:conditionally_migrate)
      info '[deploy:migrate_all_dbs] Checking changes in db' if conditionally_migrate
      if conditionally_migrate && test(:diff, "-qr #{release_path}/db #{current_path}/db")
        info '[deploy:migrate_all_dbs] Skip `deploy:migrate_all_dbs` (nothing changed in db)'
      else
        info '[deploy:migrate_all_dbs] Run `rake db:migrate_all_dbs`'
        # NOTE: We access instance variable since the accessor was only added recently. Once capistrano-rails depends on rake 11+, we can revert the following line
        invoke :'deploy:migrating_all_dbs' unless Rake::Task[:'deploy:migrating_all_dbs'].instance_variable_get(:@already_invoked)
      end
    end
  end

  desc 'Runs rake db:migrate'
  task migrating_all_dbs: [:set_rails_env] do
    envs = get_all_env
    envs.each do |rails_env|
      puts "Task is invoked"
      on fetch(:migration_servers) do
        puts fetch(:migration_servers)
        within release_path do
          puts release_path
          with rails_env: rails_env.first do
            puts "Migration for #{rails_env.first} is runing"
            execute :rake, 'db:migrate'
          end
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate_all_dbs'
end

namespace :load do
  task :defaults do
    set :conditionally_migrate,           fetch(:conditionally_migrate, false)
    set :migration_role,                  fetch(:migration_role, :db)
    set :migration_servers, -> { primary( fetch(:migration_role)) }
    set :all_rails_envs, get_all_env
  end
end
