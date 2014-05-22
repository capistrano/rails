# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:compile_assets`

Some rails specific options.

```ruby
set :rails_env, 'staging'                  # If the environment differs from the stage name
set :migration_role, 'migrator'            # Defaults to 'db'
set :conditionally_migrate, true           # Defaults to false
set :assets_roles, [:web, :app]            # Defaults to [:web]
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
