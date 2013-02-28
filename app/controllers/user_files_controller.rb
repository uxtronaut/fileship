class UserFilesController < ApplicationController

  prepend_before_filter RubyCAS::Filter, :except => [:show, :enter_password, :check_password]
  #prepend_before_filter RubyCAS::GatewayFilter, :only => [:show, :enter_password, :check_password]

  before_filter :get_user_file, :except => [:show, :create, :new]
  before_filter :get_folder, :except => :show

  before_filter :get_upload, :only => :create

  def show
    @user_file = UserFile.find_by_link_token(params[:link_token]) || UserFile.find(params[:id])

    if @user_file.password && (@user_file.folder.user != @current_user)
      redirect_to enter_password_user_file_path(@user_file), :notice => "Enter the password for #{@user_file.name}"
      return
    end

    send_user_file
  end

  def enter_password
  end

  def check_password
    if params[:user_file][:password] == @user_file.password
      send_user_file
      return
    end
    @user_file.errors.add :password, "Password didn't match"
    render :enter_password, :alert => 'Password did not match...'
  end

  def new
    @user_file = UserFile.new
  end

  def create
    respond_to do |format|
      format.html do
        @user_file = @folder.user_files.build(params[:user_file])
        if @user_file.save
          redirect_to folder_url(@folder), :notice => "Uploaded #{@user_file.name}"
          return
        else
          render :action => 'new'
          return
        end
      end

      format.json do
        @new_file.close
        @user_file = @folder.user_files.build({
          :attachment => @new_file
        })

        if @user_file.save
          render :json => {:success => true}, :content_type => 'text/plain'
          return
        else
          render :json => {:success => false, :errors => @user_file.errors}, :content_type => 'text/plain'
          return
        end
      end
    end
  end

  def edit
  end

  def update
    if @user_file.update_attributes(params[:user_file])
      respond_to do |format|
        format.js { render @folder, :formats => [:html] }
      end
    else
      respond_to do |format|
        format.js do
          partial = params[:user_file][:password] ? 'user_files/password_form' : 'user_files/rename_form'
          render({
            :partial => partial,
            :locals => {:user_file => @user_file},
            :formats => [:html],
            :status => :bad_request
          })
        end
      end
    end
  end

  def destroy
    if @user_file.destroy
      respond_to do |format|
        format.js { render @folder, :formats => [:html] }
      end
    end
  end

  def email
    respond_to do |format|
      format.js { render @folder, :formats => [:html] }
    end
  end

  def share
  end

  private

    def get_user_file
      @user_file = UserFile.find(params[:id])
    end

    def get_folder
      if params[:folder_id]
        @folder = Folder.find(params[:folder_id])
      else
        @folder = @user_file.folder
      end
    end

    def get_upload
      if params[:qqfile]
        file_name = params[:qqfile].respond_to?(:original_filename) ? params[:qqfile].original_filename : params[:qqfile]
        @new_file = File.open(Rails.root.join('tmp', file_name), "wb+")
        @new_file.write request.raw_post
      end
    end

    def send_user_file
      send_file @user_file.attachment.file.path, :filename => @user_file.name
    end

end
