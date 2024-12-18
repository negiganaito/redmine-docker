# encoding: utf-8
#
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

require File.expand_path('../../test_helper', __FILE__)

class CmsHelperTest < ActionView::TestCase
  include RedmineupCms::TestCase::TestHelper
  include ApplicationHelper
  include RedmineupCms::CmsHelper
  include ERB::Util

  fixtures :projects, :users

  RedmineupCms::TestCase.create_fixtures([:cms_layouts, :cms_snippets, :cms_pages, :cms_parts,
                                        :cms_page_fields, :cms_menus, :cms_content_versions])

  def test_filter_options_for_select
    assert_select_in filter_options_for_select, 'option[value=Textile]', text: 'Textile'
    assert_select_in filter_options_for_select, 'option[value=Scss]', text: 'Scss'
  end
end
