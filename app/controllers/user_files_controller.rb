class UserFilesController < ApplicationController

  prepend_before_filter RubyCAS::Filter

  before_filter :get_folder, :except => :show
  before_filter :get_upload, :only => :create

  def show
    @user_file = UserFile.find(params[:id])
    send_file @user_file.attachment.file.path, :filename => @user_file.attachment.file.filename
  end

  def new
    @user_file = @folder.user_files.build
  end

  def create
    respond_to do |format|
      format.html do
        @user_file = @folder.user_files.build(params[:user_file])
        if @user_file.save
          redirect_to folder_url(@folder), :notice => "Uploaded #{@user_file.attachment.file.filename}"
          return
        else
          render :action => 'new'
          return
        end
      end

      format.json do
        @user_file = @folder.user_files.build({
          :attachment => @new_file
        })
        @new_file.close

        if @user_file.save
          render :json => {:success => true}
          return
        else
          render :json => {:success => false, :errors => @user_file.errors}
          return
        end
      end
    end
  end

  private

    def get_folder
      @folder = Folder.find(params[:folder_id])
    end

    def get_upload
      if params[:qqfile]
        file_name = params[:qqfile].respond_to?(:original_filename) ? params[:qqfile].original_filename : params[:qqfile]
        @new_file = File.open(Rails.root.join('tmp', file_name), "wb+")
        @new_file.write request.body.read
      end
    end

end
