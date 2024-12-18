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
    module Tags
      module HomePath
        class HomePath < ::Liquid::Tag
          include Rails.application.routes.url_helpers

          def render(_context)
            if CmsSite.language != Setting.default_language
              if page = CmsPage.where(slug: CmsSite.language, parent: nil).first
                path = Redmineup::PageDrop.new(page).url
              end
            end
            path ||= home_path
          end
        end
      end

      ::Liquid::Template.register_tag('home_path'.freeze, HomePath::HomePath)
    end
  end
end
