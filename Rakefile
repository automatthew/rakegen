%w{rubygems}.each do |dep|
  require dep
end

Version = '0.6.2'

task :default => [:test]

begin
  gem 'echoe', '>=2.7'
  require 'echoe'
  Echoe.new('genitor', Version) do |p|
    p.project = 'genitor'
    p.summary = "Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah."
    p.author = "Matthew King"
    p.email = "automatthew@gmail.com"
    p.ignore_pattern = /^(\.git).+/
    p.test_pattern = "test/test_*.rb"
    p.dependencies << "rake"
    p.dependencies << "erubis"
  end
rescue
  "(ignored echoe gemification, as you don't have the Right Stuff)"
end
