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

class CmsPageField < defined?(ApplicationRecord) ? ApplicationRecord : ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :page, class_name: 'CmsPage', foreign_key: 'page_id'

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => 'page_id'
  validates_format_of :name, :with => /\A(?!\d+$)[\.a-z0-9\-_]*\z/i

  safe_attributes 'name',
                  'content',
                  'page_id'

  after_commit :touch_page

  private

  def touch_page
    return unless page
    page.touch
    page.expire_cache
  end
end
