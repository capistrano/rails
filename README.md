# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:compile_assets`

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
end
```

Run the following command to install the gems:

```
bundle install
```

Then run the generator to create a basic set of configuration files:

```
bundle exec cap install
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
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2

# Defaults to the primary :db server
set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role)) }
```

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
