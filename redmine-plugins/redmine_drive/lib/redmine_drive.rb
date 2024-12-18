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

module RedmineDrive
  def self.settings
    Setting.plugin_redmine_drive
  end

  def self.storage_size
    settings['storage_size'].to_f if settings['storage_size'].present?
  end

  def self.storage_size_in_bytes
    storage_size * 1024 * 1024 if storage_size
  end

  def self.progress
    return unless storage_size

    if storage_size.positive?
      (100 * (DriveEntry.total_size / 1024 / 1024) / storage_size).round(1)
    else
      100
    end
  end

  def self.projects
    Project.active.has_module(:drive)
  end

  def self.show_in_top_menu?
    settings['drive_show_in_top_menu'].to_i > 0
  end
end

REDMINE_DRIVE_REQUIRED_FILES = [
  'redmine_drive/hooks/views_issues_hook',
  'redmine_drive/hooks/controller_issues_hook',
  'redmine_drive/hooks/layouts_base_hook',
  'redmine_drive/patches/issue_patch',
  'redmine_drive/patches/project_patch',
  'redmine_drive/patches/attachments_controller_patch',
  'redmine_drive/patches/issues_controller_patch',
  'redmine_drive/patches/queries_controller_patch',
  'redmine_drive/patches/issues_helper_patch',
  'redmine_drive/virtual_file_system/file_system',
  'redmine_drive/virtual_file_system/drive_entry_interface',
  'redmine_drive/virtual_file_system/virtual_folder',
  'redmine_drive/virtual_file_system/root_folder',
  'redmine_drive/virtual_file_system/project_folder',
]

base_url = File.dirname(__FILE__)
REDMINE_DRIVE_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }
