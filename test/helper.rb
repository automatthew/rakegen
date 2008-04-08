%w( rubygems test/spec mocha redgreen English ).each { |f| require f }

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'genitor'