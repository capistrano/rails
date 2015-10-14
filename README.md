# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:compile_assets`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
```

## Usage

Require everything (`bundler`, `rails/assets` and `rails/migrations`):

```ruby
# Capfile
require 'capistrano/rails'
```

Or require just what you need manually:

```ruby
# Capfile
require 'capistrano/bundler' # Rails needs Bundler, right?
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
```

Please note that any `require`s should be placed in `Capfile`, not in `config/deploy.rb`.

You can tweak some Rails-specific options in `config/deploy.rb`:

```ruby
# If the environment differs from the stage name
set :rails_env, 'staging'

# Defaults to 'db'
set :migration_role, 'migrator'

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
set :assets_prefix, 'prepackaged-assets'

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
```

### Cleanup

To cleanup assets after compilation (which is a good idea on Rails 4), you can enable `rake assets:cleanup` on every deploy:

```ruby
after 'deploy:updated', 'deploy:cleanup_assets'
```

Concider not using this task on Rails 3, because the behaviour under Rails 3 [is different](https://github.com/capistrano/rails/issues/142).

### Symlinks

You'll probably want to symlink Rails shared files and directories like `log`, `tmp` and `public/uploads`.
Make sure you enable it by setting `linked_dirs` and `linked_files` options:

```ruby
# deploy.rb
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
