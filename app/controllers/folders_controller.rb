class FoldersController < ApplicationController

  prepend_before_filter RubyCAS::Filter

  respond_to :html, :json

  def index
    redirect_to @current_user.home_folder
  end

  def show
    @folder = Folder.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render :partial => 'folders/folder.html', :object => @folder
      end
    end
  end
end
