
# Gem::Specification for Rakegen-0.6.5
# Originally generated by Echoe

Gem::Specification.new do |s|
  s.name = %q{rakegen}
  s.version = "0.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew King"]
  s.date = %q{2008-09-01}
  s.description = %q{Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah.}
  s.email = %q{automatthew@gmail.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/rakegen/polite_file.rb", "lib/rakegen.rb", "LICENSE", "README"]
  s.files = ["CHANGELOG", "lib/rakegen/polite_file.rb", "lib/rakegen.rb", "LICENSE", "README", "test/helper.rb", "test/test_polite_file.rb", "test/test_rakegen.rb", "test/testdata/app/alpha/beta/five.erb", "test/testdata/app/four.erb", "test/testdata/app/one", "test/testdata/app/six.textile", "test/testdata/app/three.rb", "test/testdata/app/two.txt", "Manifest", "rakegen.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rakegen", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rakegen}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah.}
  s.test_files = ["test/test_polite_file.rb", "test/test_rakegen.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<erubis>, [">= 0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<highline>, [">= 0"])
  end
end


# # Original Rakefile source (requires the Echoe gem):
# 
# %w{rubygems}.each do |dep|
#   require dep
# end
# 
# Version = '0.6.5'
# 
# task :default => [:test]
# 
# begin
#   gem 'echoe', '>=2.7'
#   require 'echoe'
#   Echoe.new('rakegen', Version) do |p|
#     p.project = 'rakegen'
#     p.summary = "Generation and updation of projects from templates.  Rake-powered, for sustainable blah blah."
#     p.author = "Matthew King"
#     p.email = "automatthew@gmail.com"
#     p.ignore_pattern = /^(\.git).+/
#     p.test_pattern = "test/test_*.rb"
#     p.dependencies << "rake"
#     p.dependencies << "erubis"
#     p.dependencies << "highline"
#   end
# rescue
#   "(ignored echoe gemification, as you don't have the Right Stuff)"
# end