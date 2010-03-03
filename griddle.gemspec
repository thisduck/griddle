# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{griddle}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Mongeau"]
  s.date = %q{2010-03-03}
  s.description = %q{GridFS made simple...}
  s.email = %q{matt@toastyapps.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/griddle.rb",
     "lib/griddle/attachment.rb",
     "lib/griddle/has_grid_attachment.rb",
     "lib/griddle/style.rb",
     "lib/griddle/upfile.rb",
     "rails/init.rb",
     "test/attachment_test.rb",
     "test/fixtures/baboon.jpg",
     "test/fixtures/fox.jpg",
     "test/fixtures/sample.pdf",
     "test/has_attachment_test.rb",
     "test/models.rb",
     "test/style_test.rb",
     "test/test_helper.rb",
     "test/upfile_test.rb"
  ]
  s.homepage = %q{http://github.com/toastyapps/griddle}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{GridFS made simple.}
  s.test_files = [
    "test/attachment_test.rb",
     "test/has_attachment_test.rb",
     "test/models.rb",
     "test/style_test.rb",
     "test/test_helper.rb",
     "test/upfile_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0"])
  end
end
