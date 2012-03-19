class FoldersController < ApplicationController

  prepend_before_filter RubyCAS::Filter

  before_filter :get_folder, :only => [:show, :update]
  before_filter :can_not_rename_home_folder, :only => :update

  respond_to :html, :json

  def index
    redirect_to @current_user.home_folder
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
    @parent_folder = Folder.find(params[:folder_id])
    @folder = @parent_folder.children.build(params[:folder])

    if @folder.save
      render :partial => 'folder', :object => @parent_folder, :formats => [:html]
    else
      render ({
        :partial => 'new_form',
        :locals => {:folder => @folder},
        :formats => [:html],
        :status => :bad_request
      })
    end
  end

  def update

    if @allowed_rename && @folder.update_attributes(params[:folder])
      render @folder, :formats => [:html]
    else
      render ({
        :partial => 'rename_form',
        :locals => {:folder => @folder},
        :formats => [:html],
        :status => :bad_request
      })
    end
  end

  private
    def get_folder
      @folder = Folder.find(params[:id])
    end

    def can_not_rename_home_folder
      @allowed_rename = true
      if @folder == @current_user.home_folder
        @folder.errors.add :name, "can't rename home folder"
        @allowed_rename = false
      end
    end

end
