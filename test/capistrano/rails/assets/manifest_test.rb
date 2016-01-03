require "test_helper"
require "capistrano/rails/assets/manifest"

class Capistrano::Rails::Assets::ManifestTest < Minitest::Test
  include Fixtures

  def setup
    @ssh = FakeSSH.new
  end

  def test_backup_sprockets_3_manifest
    scenario("sprockets_3_manifest") do |manifest, dsl|
      manifest.backup(@ssh)

      assert_file_exists(
        dsl.release_path.join(
          "assets_manifest_backup",
          ".sprockets-manifest-9b1cb4b13648eb78ff92d64294703663.json"
        )
      )
    end
  end

  def test_restore_sprockets_3_manifest
    scenario("sprockets_3_backup") do |manifest, dsl|
      manifest.restore(@ssh)

      assert_file_contents(
        "Restored!",
        dsl.release_path.join(
          "public",
          "assets",
          ".sprockets-manifest-9b1cb4b13648eb78ff92d64294703663.json"
        )
      )
    end
  end

  def test_backup_sprockets_2_manifest
    scenario("sprockets_2_manifest") do |manifest, dsl|
      manifest.backup(@ssh)

      assert_file_exists(
        dsl.release_path.join(
          "assets_manifest_backup",
          "manifest-9b1cb4b13648eb78ff92d64294703663.json"
        )
      )
    end
  end

  def test_restore_sprockets_2_manifest
    scenario("sprockets_2_backup") do |manifest, dsl|
      manifest.restore(@ssh)

      assert_file_contents(
        "Restored!",
        dsl.release_path.join(
          "public",
          "assets",
          "manifest-9b1cb4b13648eb78ff92d64294703663.json"
        )
      )
    end
  end

  def test_backup_with_custom_settings
    scenario("custom_settings") do |manifest, dsl|
      dsl.set(:assets_prefix, "static")
      dsl.set(:asset_manifest_backup_directory, "backup")
      dsl.set(:asset_manifest_patterns, %w(.the-manifest*))

      manifest.backup(@ssh)

      assert_file_exists(dsl.release_path.join("backup", ".the-manifest.json"))
    end
  end

  private

  def scenario(fixture)
    within_copy_of_fixture(fixture) do |dir|
      dsl = FakeDSL.new(dir)
      manifest = Capistrano::Rails::Assets::Manifest.new(dsl)
      yield(manifest, dsl)
    end
  end

  def assert_file_exists(path)
    assert_predicate(path, :file?)
  end

  def assert_file_contents(contents, path)
    assert_equal(contents.strip, IO.read(path).strip)
  end
end
