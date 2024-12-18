# This file is a part of Redmin CMS (redmine_cms) plugin,
# CMS plugin for redmine
#
# Copyright (C) 2011-2024 RedmineUP
# http://www.redmineup.com/
#
# redmine_cms is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_cms is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_cms.  If not, see <http://www.gnu.org/licenses/>.

module RedmineupCms
  module Liquid
    module Filters
      module Drops
        # Returns drop default object
        #
        # input - LiquidDrop name
        #
        def redmine_drop(input, method_name=nil)
          drop_klass_name = input.classify
          return unless Object.const_defined?(drop_klass_name)
          drop_klass = drop_klass_name.constantize
          return unless drop_klass.respond_to?(:default_drop)
          drop = drop_klass.default_drop
          if method_name && drop.respond_to?(method_name)
            drop.method(method_name).call
          else
            drop
          end
        end
      end # module Drops
    end
  end

  ::Liquid::Template.register_filter(RedmineupCms::Liquid::Filters::Drops)
end
