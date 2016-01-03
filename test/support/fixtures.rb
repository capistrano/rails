require "fileutils"
require "tmpdir"

module Fixtures
  private

  def within_copy_of_fixture(name)
    fixture = fixtures_path.join(name)
    fail "Fixture does not exist! #{fixture}" unless fixture.directory?

    Dir.mktmpdir do |tempdir|
      FileUtils.cp_r(fixture, tempdir)
      copy = Pathname(tempdir).join(name)
      Dir.chdir(copy) do
        yield(Pathname.new(copy))
      end
    end
  end

  def fixtures_path
    Pathname.new("../../fixtures").expand_path(__FILE__)
  end
end
