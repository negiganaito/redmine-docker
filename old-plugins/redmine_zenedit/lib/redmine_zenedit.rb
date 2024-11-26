# This file is a part of Redmine ZenEdit (redmine_zenedit) plugin,
# editing enhancement plugin for Redmine
#
# Copyright (C) 2011-2024 RedmineUP
# http://www.redmineup.com/
#
# redmine_zenedit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_zenedit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_zenedit.  If not, see <http://www.gnu.org/licenses/>.

module RedmineZenedit
  def self.settings() Setting.plugin_redmine_zenedit end

  def self.draft_enabled?
    settings['disable_drafts'].blank? || settings['disable_drafts'] != '1'
  end

  def self.user_mentions?
    false
  end

  def self.issue_mentions?
    false
  end

  def self.view_indicator_enabled?
    false
  end
end

REDMINE_ZENEDIT_REQUIRED_FILES = [
  'redmine_zenedit/patches/wiki_formatting_helpers_patch',
]

base_url = File.dirname(__FILE__)
REDMINE_ZENEDIT_REQUIRED_FILES.each { |file| require(base_url + '/' + file) }
