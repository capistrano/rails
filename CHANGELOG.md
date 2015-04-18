# 1.1.3 (Apr 18 2015)

* Fixed no_release behaviour (https://github.com/capistrano/rails/pull/95)
* Allow assets manifest backup with folder "manifests" (https://github.com/capistrano/rails/pull/92)
* Handle Sprocket 3 manifest filename

# 1.1.2 (Sep 1 2014)

* rails_env is set before deploy (https://github.com/capistrano/rails/pull/66)
* with `conditionally_migrate` option enabled you can skip `db:migrate` if there were no new migrations (https://github.com/capistrano/rails/pull/71)
* Allow early overriding of assets_* parameters (https://github.com/capistrano/rails/pull/73)

# 1.1.1

* New `asset_roles` options: https://github.com/capistrano/rails/pull/30
* normalized task spelling: 'deploy:normalise_assets' is now 'deploy:normalize_assets'
* depend on capistrano 3.1 to support multiple role arguments

# 1.1.0

* set rails_env even if capistrano-rails was required partly
* depend on capistrano-bundler
* require bundler with capistrano-rails/all

# 1.0.0

Initial release
