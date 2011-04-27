# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "./spree_ecs/base.rb")
Dir.glob(File.join(File.dirname(__FILE__), "./spree_ecs/**/*.rb")) {  |c| require(c) }

module SpreeEcs
end
