# -*- encoding: utf-8 -*-
require File.expand_path('../lib/listingcheck_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joost Hietbrink"]
  gem.email         = ["joost@joopp.com"]
  gem.description   = %q{Ruby API to use the ListingCheck REST API.}
  gem.summary       = %q{Ruby API to use the ListingCheck REST API.}
  gem.homepage      = "http://www.listingcheck.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "listingcheck_api"
  gem.require_paths = ["lib"]
  gem.version       = ListingcheckApi::VERSION

  gem.add_dependency('api_smith')
end
