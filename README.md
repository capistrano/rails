# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:normalise_assets`

Tasks are currently early examples.

Some rails specific options.

```ruby
set :rails_env, 'staging'       # If the environment differs from the stage
set :migration_role, 'migrator' # Defaults to 'db'
```

If you need to touch `public/images`, `public/javascripts` and `public/stylesheets` on each deploy:

```ruby
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
```

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-rails'

And then execute:

    $ bundle --binstubs
    $ cap install
    
### Using a specific version of Capistrano

You do not need to include the Capistrano gem in your gemfile as it is defined
as a dependency in the Capistrano::Rails gem. If you do want to include the
Capistrano gem (because you want to use an specific version), then you need to
make sure to add `require: false` to it like this:

    gem 'capistrano', github: 'capistrano/capistrano', branch: 'v3', require: false
    gem 'capistrano-rails'

## Usage

    # Capfile

    require 'capistrano/rails'

    # or require just what you need

    require 'capistrano/rails/assets'
    require 'capistrano/rails/migrations'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
