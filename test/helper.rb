%w( rubygems test/spec mocha redgreen English ).each { |f| require f }

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'genitor'

TEST_DIR = File.join(File.dirname(__FILE__), "testdata")
TEST_APP = File.join(TEST_DIR, "app")
COPY_FILE = File.join(TEST_DIR, "copy")
CREATE_FILE = File.join(TEST_DIR, "create_only")
TEMPLATE_FILE = File.join(TEST_DIR, "template.erb")