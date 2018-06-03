# [master][]

* Your contribution here!

# [1.4.0][] (Jun 2 2018)

* Added option ':assets_manifests' to support custom manifest file path ([#216](https://github.com/capistrano/rails/pull/216))

# [1.3.1][] (Nov 21 2017)

This release simply adds the MIT license to the capistrano-rails gemspec. There are no code changes. See [#205](https://github.com/capistrano/rails/issues/205).

# [1.3.0][] (Jun 9 2017)

* rails_assets_groups config option to set RAILS_GROUPS (https://github.com/capistrano/rails/pull/135)

# [1.2.3][] (Mar 4 2017)

* [#200](https://github.com/capistrano/rails/pull/200): Don't link public/assets if public is already linked - [@mattbrictson](https://github.com/mattbrictson)

# [1.2.2][] (Jan 10 2017)

* Restored compatibility with older versions of Rake (< 11.0.0), introduced in previous change. (@toupeira)

# [1.2.1][] (Dec 23 2016)

* Diff db directory recursively
* Avoid warning while running migrations on multiple servers (#189)

# [1.2.0][] (Oct 25 2016)

* Diff entire db directory when determining if migrations are needed

# 1.1.8 (Sep 13 2016)

* Handle arrays passed into `normalize_asset_timestamps` correctly (#184)

# 1.1.7 (Jun 10 2016)

* call `Array#uniq` in `deploy:set_linked_dirs` task to remove duplicated :linked_dirs
* Add `migration_servers` configuration (#168)

# 1.1.6 (Jan 19 2016)

* Add `rake assets:clobber` task from Rails (#149)
* Make `assets:clean` capable with zsh (#150)
* Split `deploy:migrate` to allow for finer hook-control (#148)
* Fix for parsing ls output in detect_manifest_path (#133)

# 1.1.5 (Oct 15 2015)

* Disable `deploy:cleanup_assets` by default due to undesirable behavior in Rails 3. Use `set :keep_assets, 2` to explicitly enable this feature for Rails 4.

# 1.1.4 (Oct 10 2015)

* Fixing bug with normalize_assets typo #138
* Cleanup assets after:updated (#136)
* Fixed linked_dirs containing default value of assets_prefix (#125)

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

[master]: https://github.com/capistrano/rails/compare/v1.4.0...HEAD
[1.4.0]: https://github.com/capistrano/rails/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/capistrano/rails/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/capistrano/rails/compare/v1.2.3...v1.3.0
[1.2.3]: https://github.com/capistrano/rails/compare/v1.2.2...v1.2.3
[1.2.2]: https://github.com/capistrano/rails/compare/v1.2.1...v1.2.2
[1.2.1]: https://github.com/capistrano/rails/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/capistrano/rails/compare/v1.1.8...v1.2.0
