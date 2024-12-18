# This file is a part of Redmin Drive (redmine_drive) plugin,
# Filse storage plugin for redmine
#
# Copyright (C) 2011-2024 RedmineUP
# http://www.redmineup.com/
#
# redmine_drive is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_drive is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_drive.  If not, see <http://www.gnu.org/licenses/>.

class CreateIssueDriveFiles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :issue_drive_files do |t|
      t.references :issue, foreign_key: true
      t.references :drive_entry, foreign_key: true
      t.datetime :created_at, null: false
    end

    add_index :issue_drive_files, [:drive_entry_id, :issue_id], unique: true
  end

  def self.down
    drop_table :issue_drive_files
  end
end
