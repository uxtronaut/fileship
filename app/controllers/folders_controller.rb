class FoldersController < ApplicationController

  prepend_before_filter RubyCAS::Filter

  before_filter :get_folder
  before_filter :get_parent_folder
  before_filter :check_permission, :except => :index
  before_filter :can_not_rename_home_folder, :only => :update

  respond_to :html, :json

  def index
    redirect_to @current_user.is_admin? ? Folder.root : @current_user.home_folder
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        render @folder, :formats => [:html]
      end
    end
  end

  def create
    @folder = @parent_folder.children.build(params[:folder])
    @folder.user = @current_user

    if @folder.save

      respond_to do |format|
        format.html do
          render @parent_folder
        end

        format.js do
          render :partial => 'folder', :object => @parent_folder, :formats => [:html]
        end
      end

    else

      respond_to do |format|
        format.html { render :new }

        format.js do
          render(
            :partial => 'new_form',
            :locals => {:folder => @folder},
            :formats => [:html],
            :status => :bad_request
          )
        end
      end

    end
  end

  def update
    if @allowed_rename && @folder.update_attributes(params[:folder])
      render @folder, :formats => [:html]
    else
      render({
        :partial => 'rename_form',
        :locals => {:folder => @folder},
        :formats => [:html],
        :status => :bad_request
      })
    end
  end

  private
    def get_folder
      if params[:id]
        @folder = Folder.find(params[:id])
      else
        @folder = Folder.new
      end
    end

    def get_parent_folder
      if params[:folder_id]
        @parent_folder = Folder.find(params[:folder_id])
      else
        @parent_folder = Folder.new
      end
    end

    def check_permission
      unless @current_user.is_admin? || @folder.user == @current_user || @parent_folder.user == @current_user
        render_403
      end
    end

    def can_not_rename_home_folder
      @allowed_rename = true
      if @folder == @current_user.home_folder
        @folder.errors.add :name, "can't rename home folder"
        @allowed_rename = false
      end
    end

end
