load File.expand_path("../set_rails_env.rake", __FILE__)

module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do
  desc 'Normalize asset timestamps'
  task :normalize_assets => [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      assets = fetch(:normalize_asset_timestamps)
      if assets
        within release_path do
          execute :find, "#{assets} -exec touch -t #{asset_timestamp} {} ';'; true"
        end
      end
    end
  end

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:rsync' if rsync_mode?
    invoke 'deploy:assets:backup_manifest'
  end

  # FIXME: it removes every asset it has just compiled
  desc 'Cleanup expired assets'
  task :cleanup_assets => [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:clean"
        end
      end
    end
  end

  desc 'Rollback assets'
  task :rollback_assets => [:set_rails_env] do
    begin
      invoke 'deploy:assets:restore_manifest'
    rescue Capistrano::FileNotFound
      invoke 'deploy:compile_assets'
    end
  end

  after 'deploy:updated', 'deploy:compile_assets'
  # NOTE: we don't want to remove assets we've just compiled
  # after 'deploy:updated', 'deploy:cleanup_assets'
  after 'deploy:updated', 'deploy:normalize_assets'
  after 'deploy:reverted', 'deploy:rollback_assets'

  namespace :assets do
    task :precompile do
      roles = rsync_mode? ? fetch(:compile_assets_roles) : fetch(:assets_roles)

      on release_roles(roles) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "assets:precompile"
          end
        end
      end
    end

    # Copy assets from one primary source machine that compiled them
    # to other :assets_roles machines that have not. In default
    # operation, all machines compile their own assets.
    task :rsync do
      asset_path = release_path.join('public', fetch(:assets_prefix))
      rsync_opts = '--archive --acls --xattrs'
      primary_source_string = "#{rsync_primary_source.hostname}:#{asset_path}/"

      on rsync_destination_roles do
        within release_path do
          execute :mkdir, '-p', asset_path
          execute :rsync, rsync_opts, primary_source_string, asset_path
        end
      end
    end

    task :backup_manifest do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          backup_path = release_path.join('assets_manifest_backup')

          execute :mkdir, '-p', backup_path
          execute :cp,
            detect_manifest_path,
            backup_path
        end
      end
    end

    task :restore_manifest do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          target = detect_manifest_path
          source = release_path.join('assets_manifest_backup', File.basename(target))
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

    def detect_manifest_path
      %w(
        .sprockets-manifest*
        manifest*.*
      ).each do |pattern|
        candidate = release_path.join('public', fetch(:assets_prefix), pattern)
        return capture(:ls, candidate).strip if test(:ls, candidate)
      end
      msg = 'Rails assets manifest file not found.'
      warn msg
      fail Capistrano::FileNotFound, msg
    end

    def rsync_source_roles
      release_roles(fetch(:compile_assets_roles))
    end

    def rsync_destination_roles
      release_roles(fetch(:assets_roles)) - rsync_source_roles
    end

    def rsync_primary_source
      rsync_source_roles.first
    end

    def rsync_mode?
      rsync_source_roles.any?
    end
  end
end

namespace :load do
  task :defaults do
    set :compile_assets_roles, fetch(:compile_assets_roles, [])
    set :assets_roles, fetch(:assets_roles, [:web])
    set :assets_prefix, fetch(:assets_prefix, 'assets')
    set :linked_dirs, fetch(:linked_dirs, []).push("public/#{fetch(:assets_prefix)}")
  end
end
