%w( rubygems test/spec mocha redgreen English ).each { |f| require f }

$:.unshift "../lib"
require 'rakegen'