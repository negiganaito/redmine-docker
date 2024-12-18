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

class CmsPagesController < ApplicationController
  include Redmine::I18n
  include CmsPagesHelper
  helper :queries
  include QueriesHelper

  before_action :authorize_page_edit, :except => [:show, :search]
  before_action :find_page, :only => [:show, :destroy, :preview, :edit, :update, :expire_cache]
  before_action :authorize_page, :only => [:show]
  before_action :set_locale, :only => [:show]
  before_action :require_admin, :only => :destroy

  accept_api_auth :index, :show, :create, :update, :destroy

  helper :attachments
  helper :cms_menus
  helper :cms_parts
  helper :cms

  protect_from_forgery :except => :show

  def index
    retrieve_pages_query
    conditions = {}
    if @query.filters && @query.filters.empty? && params[:search].nil?
      parent = CmsPage.where(:id => params[:parent_id].delete('page-')).first if params[:parent_id]
      conditions[:parent_id] = parent.try(:id)
    end

    @cms_pages = @query.results_scope(:search => params[:search], :conditions => conditions).preload(:children_pages)

    if request.xhr?
      @cms_pages.any? ? render(:partial => 'pages_list_content') : render(:nothing => true)
    else
      render :action => 'index'
    end
  end

  def show
    if params[:version]
      return false unless authorize_page_edit
      @current_version = @cms_page.set_content_from_version(params[:version])
    end

    # if @cms_page.is_cached?
    #   expires_in RedmineupCms.cache_expires_in.minutes, :public => true, :private => false
    # else
    #   expires_in nil, :private => true, "no-cache" => true
    #   headers['ETag'] = ''
    # end
    unless @cms_page.layout.blank?
      render(:plain => @cms_page.process(self), :layout => false)
    end
  end

  def search
    q = (params[:q] || params[:term]).to_s.strip
    if params[:cms_page] && page = CmsPage.find_by_name(params[:cms_page])
      scope = case params[:children]
              when 'leaves'
                page.leaves
              when 'descendants'
                page.descendants
              else
                page.children
              end
    else
      scope = CmsPage.visible
    end
    scope = scope.includes(:tags)
    scope = scope.limit(params[:limit] || 10)
    q.split(' ').collect { |search_string| scope = scope.like(search_string) } if q.present?
    scope = scope.order(:title)

    if params[:tag]
      tags = params[:tag].split(',')
      tag_options = case params[:match]
                    when 'any'
                      { :match_all => false }
                    when 'exclude'
                      { :exclude => true }
                    else
                      { :match_all => true }
                    end
      scope = scope.tagged_with(tags, tag_options)
    end

    @cms_pages = scope
    render :json => @cms_pages.map { |page| { 'name' => page.name,
                                          'slug' => page.slug,
                                          'path' => page.path,
                                          'title' => page.title,
                                          'tags' => page.tag_list } }
  end

  def preview
    @current_version = @cms_page.set_content_from_version(params[:version]) if params[:version]
    @cms_object = @cms_page
    render :action => 'preview', :layout => 'cms_preview'
  end

  def edit
    @current_version = @cms_page.set_content_from_version(params[:version]) if params[:version]
    respond_to do |format|
      format.html { render :action => 'edit', :layout => use_layout }
    end
  end

  def new
    @cms_page = CmsPage.new
    @cms_page.page_date = Time.now
    @cms_page.safe_attributes = params[:cms_page]
    @cms_page.layout_id ||= params[:layout_id] || RedmineupCms.default_layout
    RedmineupCms.default_page_fields.each { |f| @cms_page.fields.build(:name => f) }
    @cms_page.copy_from(params[:copy_from]) if params[:copy_from]
    respond_to do |format|
      format.html { render :action => 'new', :layout => use_layout }
    end
  end

  def update
    cms_page_attributes = params[:cms_page]
    if cms_page_attributes && params[:conflict_resolution]
      case params[:conflict_resolution]
      when 'overwrite'
        cms_page_attributes = cms_page_attributes.dup
        cms_page_attributes.delete(:lock_version)
      when 'cancel'
        redirect_to edit_cms_page_path(@cms_page, :tab => params[:tab])
        return false
      end
    end
    cms_page_attributes[:tag_list] = [] if cms_page_attributes[:tag_list].blank?
    @cms_page.safe_attributes = cms_page_attributes
    attachments_chanched = @cms_page.save_attachments(params[:attachments])
    begin
      saved = @cms_page.save
    rescue ActiveRecord::StaleObjectError
      @conflict = true
      @conflict_versions = @cms_page.versions_after(params[:last_version]).to_a unless params[:last_version].blank?
    end
    if saved
      @cms_page.reload.touch if attachments_chanched
      render_attachment_warning_if_needed(@cms_page)
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default edit_cms_page_path(@cms_page, :tab => params[:tab])
        }
        format.js do
          # @cms_pages = CmsPage.includes([:layout, :author])
          render :action => 'change'
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit', :tab => params[:tab] }
        format.js { render :js => "alert('#{l(:label_cms_save_page_error)}');" }
      end
    end
  end

  def create
    @cms_page = CmsPage.new
    @cms_page.safe_attributes = params[:cms_page]
    @cms_page.author = User.current
    @cms_page.save_attachments(params[:attachments])
    if @cms_page.save
      render_attachment_warning_if_needed(@cms_page)
      flash[:notice] = l(:notice_successful_create)
      redirect_to edit_cms_page_path(@cms_page, :tab => params[:tab])
    else
      render :action => 'new', :tab => params[:tab]
    end
  end

  def destroy
    if params[:version]
      version = @cms_page.versions.where(:version => params[:version]).first
      if version.current_version?
        flash[:warning] = l(:label_cms_version_cannot_destroy_current)
      else
        version.destroy
      end
      redirect_to cms_object_history_path(@cms_page)
    else
      @cms_page.destroy
      redirect_to :controller => 'cms_pages', :action => 'index', :tab => 'pages'
    end
  end

  def expire_cache
    @cms_page.expire_cache
    redirect_to :back
  end

  private

  def authorize_page
    deny_access unless @cms_page.visible?
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_page
    page_scope = CmsPage.includes([:attachments, :parts, :layout])
    @cms_page = params[:id] ? page_scope.find_by_name(params[:id]) : page_scope.find_by_path(params[:path])
    @cms_parts = @cms_page.parts.order(:position) if @cms_page
    render_404 unless @cms_page
  end

  def authorize_page_edit
    unless RedmineupCms.allow_edit?
      deny_access
      return false
    end
    true
  end
end
