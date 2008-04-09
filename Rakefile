%w{rubygems rake/gempackagetask rake/testtask rake/rdoctask rcov/rcovtask}.each do |dep|
  require dep
end

Version = '0.5.0'

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
# 
# Rake::TestTask.new do |test|
#   test.libs << "test"
#   test.test_files = FileList["test/test_*.rb"]
# end

Rcov::RcovTask.new do |rcov|
  rcov.libs << "test"
  rcov.test_files = FileList['test/test_*.rb']
  rcov.verbose = true
end
# 
# Rake::RDocTask.new do |rdoc|
#   rdoc.main = "README"
#   rdoc.rdoc_files.include("README", "lib")
#   rdoc.rdoc_dir = "doc/html"
# end

# gem = Gem::Specification.new do |s|
#   s.name = "genitor"
#   s.summary = "Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah."
#   s.rubyforge_project = "genitor"
#   s.version = "0.5.0"
#   s.author = "Matthew King"
#   s.email = "automatthew@gmail.com"
#   s.platform = Gem::Platform::RUBY
#   %w( rake erubis).each do |dep|
#     s.add_dependency dep
#   end
#   s.files = Dir['lib/**/*.rb','examples/**/*', 'test/**/*']
#   s.has_rdoc = true
# end
# 
# Rake::GemPackageTask.new(gem) do |pkg|
#   pkg.need_zip = false
#   pkg.need_tar = false
# end
