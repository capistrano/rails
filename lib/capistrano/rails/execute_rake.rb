class SSHKit::Backend::Netssh
  def execute_rake(*args)
    execute(fetch(:rake) || :rake, *args)
  end
end
