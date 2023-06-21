# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:compile_assets`

## Installation

Add these Capistrano gems to your application's Gemfile using `require: false`:

```ruby
group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
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

# Defaults to :db role
set :migration_role, :db

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to `db:migrate`
set :migration_command, 'db:migrate'

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
set :assets_prefix, 'prepackaged-assets'

# Defaults to ["/path/to/release_path/public/#{fetch(:assets_prefix)}/.sprockets-manifest*", "/path/to/release_path/public/#{fetch(:assets_prefix)}/manifest*.*"]
# This should match config.assets.manifest in your rails config/application.rb
set :assets_manifests, ['app/assets/config/manifest.js']

# RAILS_GROUPS env value for the assets:precompile task. Default to nil.
set :rails_assets_groups, :assets

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2
```

### Symlinks

You'll probably want to symlink Rails shared files and directories like `log`, `tmp` and `public/uploads`.
Make sure you enable it by setting `linked_dirs` and `linked_files` options:

```ruby
# deploy.rb
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_files, 'config/database.yml', 'config/secrets.yml'
```

In capistrano < 3.5, before `append` was introduced, you can use `fetch` and `push` to get the same result.

### Recommendations

While migrations looks like a concern of the database layer, Rails migrations
are strictly related to the framework. Therefore, it's recommended to set the
role to `:app` instead of `:db` like:

```ruby
set :migration_role, :app
```

The advantage is you won't need to deploy your application to your database
server, and overall a better separation of concerns.

#### Uploading your master.key

You can use the below configuration to upload your `master.key` to the server if it isn't already present.

```ruby
append :linked_files, "config/master.key"

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app) do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
