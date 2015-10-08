# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checklister/version'

Gem::Specification.new do |spec|
  spec.name          = "checklister"
  spec.version       = Checklister::VERSION
  spec.authors       = ["Benjamin Thouret", "Manon Deloupy"]
  spec.email         = ["ben@2ret.com", "mdeloupy@gmail.com"]

  spec.summary       = %q{Markdown checklists to gitlab or github issue.}
  spec.description   = %q{Checklister is a CLI packaged as a Ruby gem giving you the power to transform any markdown file or url checklist into an actionable gitlab (and soon github) issue.}
  spec.homepage      = "https://github.com/benichu/checklister"
  spec.license       = "MIT"

  spec.required_ruby_version     = '>= 2.0'
  spec.required_rubygems_version = '>= 1.9'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gitlab"    , "~> 3.4.0"
  spec.add_dependency "gli"       , "~> 2.13"
  spec.add_dependency "octokit"   , "~> 4.0"

  spec.add_development_dependency "bundler"             , "~> 1.10"
  spec.add_development_dependency "coveralls"           , "~> 0.8.2"
  spec.add_development_dependency "guard"               , "~> 2.13"
  spec.add_development_dependency "guard-rspec"         , "~> 4.6"
  spec.add_development_dependency "guard-ctags-bundler"
  spec.add_development_dependency "rake"                , "~> 10.4"
  spec.add_development_dependency "rspec"               , "~> 3.3"
  spec.add_development_dependency "yard"                , "~> 0.8"
  spec.add_development_dependency "webmock"             , "~> 1.21"
end
