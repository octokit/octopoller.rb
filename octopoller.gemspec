
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "octopoller/version"

Gem::Specification.new do |spec|
  spec.name          = "octopoller"
  spec.version       = Octopoller::VERSION
  spec.authors       = ["BenEmdon"]
  spec.email         = ["benemdon@github.com"]

  spec.summary       = %q{A Ruby gem for polling and retrying actions}
  spec.description   = %q{A micro gem for polling and retrying, perfect for making repeating requests}
  spec.homepage      = "https://github.com/octokit/octopoller.rb"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.33"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
