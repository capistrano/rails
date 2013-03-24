namespace :deploy do
  desc 'Normalise asset timestamps'
  task :normalise_assets do
    on roles :web do
      within release_path do
        assets = %{public/images public/javascripts public/stylesheets}
        execute :find, "#{assets} -exec touch -t #{asset_timestamp} {} ';'; true"
      end
    end
  end

  after :finalize, 'deploy:normalise_assets'
end
