%w( rubygems test/spec mocha English ).each { |f| require f }
require 'redgreen' if ENV['TM_FILENAME'].nil?

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rakegen'

TEST_DIR = File.join(File.dirname(__FILE__), "testdata")
TEST_APP = File.join(TEST_DIR, "app")
COPY_FILE = File.join(TEST_DIR, "copy")
CREATE_FILE = File.join(TEST_DIR, "create_only")
TEMPLATE_FILE = File.join(TEST_DIR, "template.erb")