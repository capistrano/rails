load File.expand_path("../../tasks/migrations.rake", __FILE__)

set_if_empty :conditionally_migrate, false
set_if_empty :migration_role, :db
