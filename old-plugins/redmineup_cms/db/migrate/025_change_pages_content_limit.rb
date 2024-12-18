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

class ChangePagesContentLimit < ActiveRecord::Migration[4.2]
  def up
  	change_column :cms_pages, :content, :text, :limit => 1_073_741_823
  	change_column :cms_content_versions, :content, :text, :limit => 1_073_741_823
  	change_column :cms_page_fields, :content, :text
  end

  def down
  	change_column :cms_pages, :content, :text
  	change_column :cms_content_versions, :content, :text
  	change_column :cms_page_fields, :content, :string
  end
end
