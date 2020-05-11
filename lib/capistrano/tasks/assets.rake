load File.expand_path("../set_rails_env.rake", __FILE__)

module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do
  desc 'Normalize asset timestamps'
  task :normalize_assets => [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      assets = Array(fetch(:normalize_asset_timestamps, []))
      if assets.any?
        within release_path do
          execute :find, "#{assets.join(' ')} -exec touch -t #{asset_timestamp} {} ';'; true"
        end
      end
    end
  end

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:backup_manifest'
  end

  desc 'Cleanup expired assets'
  task :cleanup_assets => [:set_rails_env] do
    next unless fetch(:keep_assets)
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "'assets:clean[#{fetch(:keep_assets)}]'"
        end
      end
    end
  end

  desc 'Clobber assets'
  task :clobber_assets => [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:clobber"
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
  after 'deploy:updated', 'deploy:cleanup_assets'
  after 'deploy:updated', 'deploy:normalize_assets'
  after 'deploy:reverted', 'deploy:rollback_assets'

  namespace :assets do
    task :precompile do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), rails_groups: fetch(:rails_assets_groups) do
            execute :rake, "assets:precompile"
          end
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
          targets = detect_manifest_path.split(' ')
          sources = targets.map do |target|
            release_path.join('assets_manifest_backup', File.basename(target))
          end
          if test(:ls, *sources) && test(:ls, *targets)
            source_map = sources.zip(targets)
            source_map.each do |source, target|
              execute :cp, source, target
            end
          else
            msg = 'Rails assets manifest file (or backup file) not found.'
            warn msg
            fail Capistrano::FileNotFound, msg
          end
        end
      end
    end

    def detect_manifest_path
      fetch(:assets_manifests).each do |candidate|
        return capture(:ls, candidate).strip.gsub(/(\r|\n)/, ' ') if test(:ls, candidate)
      end
      msg = 'Rails assets manifest file not found.'
      warn msg
      fail Capistrano::FileNotFound, msg
    end
  end
end

# we can't set linked_dirs in load:defaults,
# as assets_prefix will always have a default value
namespace :deploy do
  task :set_linked_dirs do
    linked_dirs = fetch(:linked_dirs, [])
    unless linked_dirs.include?('public')
      linked_dirs << "public/#{fetch(:assets_prefix)}"
      set :linked_dirs, linked_dirs.uniq
    end
  end
end

after 'deploy:set_rails_env', 'deploy:set_linked_dirs'

namespace :load do
  task :defaults do
    set :assets_roles, fetch(:assets_roles, [:web])
    set :assets_prefix, fetch(:assets_prefix, 'assets')
    set :assets_manifests, -> {
      %w[.sprockets-manifest* manifest*.*].map do |pattern|
        release_path.join("public", fetch(:assets_prefix), pattern)
      end
    }
  end
end
