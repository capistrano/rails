$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }
require "minitest/autorun"
