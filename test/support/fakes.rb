require "forwardable"

# Simulates `set`, `fetch`, and `release_path` methods of the Capistrano DSL.
# Note that calling `set` with a Proc is not supported, but that shouldn't be
# needed for test scenarios.
class FakeDSL
  extend Forwardable
  def_delegators :@settings, :fetch

  attr_reader :release_path, :settings

  def initialize(release_path, settings={})
    @release_path = Pathname.new(release_path)
    @settings = settings
  end

  def set(key, value)
    settings[key] = value
  end
end

# Simulates SSHKit's `test` and `execute` methods by running the commands on
# in a local shell.
class FakeSSH
  def test(command)
    system(command)
  end

  def execute(*args)
    system(args.map(&:to_s).join(" ")) || fail
  end
end
