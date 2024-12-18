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

class AddPrefixToTables < ActiveRecord::Migration[4.2]
  def up
    remove_index :pages, :parent_id
    remove_index :pages, :name
    remove_index :pages, :visibility
    remove_index :pages, :layout_id
    rename_table :pages, :cms_pages
    rename_table :parts, :cms_parts
    add_index :cms_pages, :parent_id
    add_index :cms_pages, :name
    add_index :cms_pages, :visibility
    add_index :cms_pages, :layout_id
  end

  def down
    rename_table :cms_pages, :pages
    rename_table :cms_parts, :parts
  end
end
