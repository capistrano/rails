after 'deploy:updated', 'deploy:compile_assets'
after 'deploy:updated', 'deploy:normalize_assets'
after 'deploy:reverted', 'deploy:rollback_assets'

after 'deploy:updated', 'deploy:migrate'
