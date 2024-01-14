require_relative "lib/strip-tags/version"

Gem::Specification.new do |spec|
  spec.name = "strip-tags"
  spec.version = StripTags::VERSION
  spec.authors = ["Martin Moen Wulffeld"]
  spec.email = ["martin@wulffeld.dk"]

  spec.summary = "Strip tags from fields in your models."
  spec.description = "An ActiveModel extension that strips tags from attributes before validation using the strip-tags helper."
  spec.homepage = "https://github.com/wulffeld/strip-tags"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wulffeld/strip-tags"
  spec.metadata["changelog_uri"] = "https://github.com/wulffeld/strip-tags/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel", ">= 5.2"
  spec.add_development_dependency "rake"
end
