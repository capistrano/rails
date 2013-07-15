module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do
  before :starting, :set_shared_assets do
    set :linked_dirs, (fetch(:linked_dirs) || []).push('public/assets')
  end

  desc 'Normalise asset timestamps'
  task :normalise_assets do
    on roles :web do
      within release_path do
        assets = %{public/images public/javascripts public/stylesheets}
        execute :find, "#{assets} -exec touch -t #{asset_timestamp} {} ';'; true"
      end
    end
  end

  desc 'Compile assets'
  task :compile_assets do
    invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:backup_manifest'
  end

  desc 'Cleanup expired assets'
  task :cleanup_assets do
    on roles :web do
      within release_path do
        execute :rake, "assets:clean RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

  desc 'Rollback assets'
  task :rollback_assets do
    begin
      invoke 'deploy:assets:restore_manifest'
    rescue Capistrano::FileNotFound
      invoke 'deploy:compile_assets'
    end
  end

  after 'deploy:updated', 'deploy:compile_assets'
  after 'deploy:updated', 'deploy:cleanup_assets'
  after 'deploy:updated', 'deploy:normalise_assets'
  after 'deploy:reverted', 'deploy:rollback_assets'

  namespace :assets do
    task :precompile do
      on roles :web do
        within release_path do
          execute :rake, "assets:precompile RAILS_ENV=#{fetch(:stage)}"
        end
      end
    end

    task :backup_manifest do
      on roles :web do
        within release_path do
          execute :cp,
            release_path.join('public', 'assets', 'manifest*.json'),
            release_path.join('assets_manifest_backup.json')
        end
      end
    end

    task :restore_manifest do
      on roles :web do
        within release_path do
          source = release_path.join('assets_manifest_backup.json')
          target = capture(:ls, release_path.join('public', 'assets',
                                                  'manifest*')).strip
          if test "[[ -f #{source} && -f #{target} ]]"
            execute :cp, source, target
          else
            msg = 'Rails assets manifest file (or backup file) not found.'
            warn msg
            fail Capistrano::FileNotFound, msg
          end
        end
      end
    end

  end

end
