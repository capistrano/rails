# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:compile_assets`

Some rails specific options.

```ruby
set :rails_env, 'staging'                  # If the environment differs from the stage name
set :migration_role, 'migrator'            # Defaults to 'db'
set :conditionally_migrate, true           # Defaults to false. If true, it's skip migration if files in db/migrate not modified
set :assets_roles, [:web, :app]            # Defaults to [:web]
set :compile_assets_roles, [:compiler]     # Defaults to [], which means compilation runs on all :assets_roles
set :assets_prefix, 'prepackaged-assets'   # Defaults to 'assets' this should match config.assets.prefix in your rails config/application.rb
```

If you need to touch `public/images`, `public/javascripts` and `public/stylesheets` on each deploy:

```ruby
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
```

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano',  '~> 3.1'
    gem 'capistrano-rails', '~> 1.1'

## Usage

Require everything (bundler, rails/assets and rails/migrations)

    # Capfile
    require 'capistrano/rails'

Or require just what you need manually:

    # Capfile
    require 'capistrano/bundler' # Rails needs Bundler, right?
    require 'capistrano/rails/assets'
    require 'capistrano/rails/migrations'

Please note that any `require` should be placed in `Capfile`, not `config/deploy.rb`.

### Symlinks

You'll probably want to symlink Rails shared files and directories like `log`, `tmp` and `public/uploads`.
Make sure you enable it by setting `linked_dirs` and `linked_files` options:

    # deploy.rb
    set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
    set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

## Compilation & Distribution of Assets

By default, each machine within `:asset_roles` compiles its own copy of the assets.
This allows all machines to operate independently and without the need to directly
access each other.

In some instances, it is desirable to run this compilation on only one machine,
then have the resultant files distributed to the rest. This can be accomplished
by assigning a single machine to `:compile_assets_roles`.

```ruby
set :compile_assets_roles, [ :compiler ]

server 'util01', user: 'deploy', roles: [:util, :compiler]
```

For this method to work, the other machines in `:asset_roles` must be able to
directly reach the machine that compiles the assets (in this example, util01)
using the details provided in the Capistrano configuration. They must also have
`rsync` available to sync the asset files.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
