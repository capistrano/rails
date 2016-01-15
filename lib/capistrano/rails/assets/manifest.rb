require "forwardable"

module Capistrano
  module Rails
    module Assets
      # Represents a Sprockets manifest that can be backed up or restored from
      # that backup. A directory named "assets_manifest_backup" in the
      # release_path is used to hold the backup.
      #
      # Different version of Sprockets use different naming conventions for
      # the manifest, and the names are randomly generated, so globs are used
      # to locate the manifest. The default patterns are:
      #
      #   .sprockets-manifest*
      #   manifest*.*
      #
      # This can be changed with `set(:asset_manifest_patterns, [...])` using
      # the Capistrano DSL.
      #
      # Other Capistrano variables that are used:
      #
      #   :assets_prefix (default is "assets")
      #   :asset_manifest_backup_directory (default is "assets_manifest_backup")
      #
      # This class is used in assets.rake.
      #
      class Manifest
        extend Forwardable
        attr_reader :dsl
        def_delegators :dsl, :fetch, :release_path

        # Create a Manifest with a reference the Capistrano DSL. The DSL is
        # needed to access the `fetch` and `release_path` helpers.
        def initialize(dsl)
          @dsl = dsl
        end

        # Copy all files matching the `:asset_manifest_patterns` from the
        # public/assets directory to the backup directory.
        def backup(ssh)
          ssh.execute(:mkdir, "-p", backup_directory_path)
          copy_manifests(ssh, assets_directory_path, backup_directory_path)
        end

        # Copy all files matching the `:asset_manifest_patterns` from the
        # backup directory to the public/assets directory.
        def restore(ssh)
          copy_manifests(ssh, backup_directory_path, assets_directory_path)
        end

        private

        def patterns
          fetch(:asset_manifest_patterns, %w(.sprockets-manifest* manifest*.*))
        end

        def copy_manifests(ssh, src_path, dst_path)
          src_manfests = patterns.map { |p| src_path.join(p) }
          src_manfests.each do |path|
            next unless ssh.test("[ -f #{path} ]")
            ssh.execute(:cp, path, dst_path)
          end
        end

        def backup_directory
          fetch(:asset_manifest_backup_directory, "assets_manifest_backup")
        end

        def backup_directory_path
          release_path.join(backup_directory)
        end

        def assets_directory_path
          release_path.join("public", fetch(:assets_prefix, "assets"))
        end
      end
    end
  end
end
