# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_amazon_api'
  s.version     = '0.0.1'
  s.summary     = 'spree-amazon-api'
  s.description = 'spree-amazon-api'
  s.required_ruby_version = '>= 1.8.7'

  s.authors            = ['Maxim']
  s.email              = ['parallel588@gmail.com']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('rails', '>= 3.0.7')
  s.add_dependency('spree_core', '>= 0.50.2')
  s.add_dependency('spree_auth', '>= 0.50.2')
  s.add_dependency('amazon-ecs', '>= 1.2.1')
  s.add_development_dependency("rspec", ">= 2.5.2")
   s.add_development_dependency("rspec-rails", ">= 2.5.0")
end
