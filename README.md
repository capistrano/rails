# Capistrano::Rails

Rails specific tasks for Capistrano v3:

  - `cap deploy:migrate`
  - `cap deploy:normalise_assets`

Assumes that `RAILS_ENV` matches stage, tasks are currently early examples

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', version: '~> 3.0.0'
    gem 'capistrano-rails', version: '~> 1.0.0'

And then execute:

    $ bundle --binstubs
    $ cap install

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
