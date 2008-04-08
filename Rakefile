%w{rubygems rake/gempackagetask rake/testtask rake/rdoctask rcov/rcovtask}.each do |dep|
  require dep
end

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList["test/test_*.rb"]
end

Rcov::RcovTask.new do |rcov|
  rcov.libs << "test"
  rcov.test_files = FileList['test/test_*.rb']
  rcov.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_files.include("README", "lib")
  rdoc.rdoc_dir = "doc/html"
end

gem = Gem::Specification.new do |gem|
	gem.name = "genitor"
	gem.summary	= "Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah."
	gem.version = "0.5.0"
	gem.author = "Matthew King"
	gem.email = "automatthew@gmail.com"
	gem.platform = Gem::Platform::RUBY
	%w( rake erubis).each do |dep|
	  gem.add_dependency dep
	end
	gem.files = Dir['lib/**/*.rb','examples/**/*', 'test/**/*']
	gem.has_rdoc = true
end

Rake::GemPackageTask.new(gem) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end
