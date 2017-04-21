namespace :logs do

  desc 'Tail log file'
  task :tail do
    on roles(:app), in: :sequence, wait: 5 do
      execute "tail -n 500 -f #{release_path}/log/#{fetch(:stage)}.log" do |channel, stream, data|
        puts
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end

end