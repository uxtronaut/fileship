# Fileship
# Copyright (C) 2012 Oregon State University
#
#

module FoldersHelper

  def breadcrumbs(folder, crumbs='', current_folder=true)
    if folder.parent && (@current_user.is_admin? || folder.parent != Folder.root)
      crumbs = breadcrumbs(folder.parent, crumbs, false) + crumbs + (content_tag :span, '/', :class => 'divider')
    end

    crumb_text = folder == @current_user.home_folder ? 'Home' : folder.name
    crumb_link = link_to_unless current_folder, crumb_text, folder
    crumb = current_folder ? (content_tag :li, crumb_link, :class => 'active') : (content_tag :li, crumb_link)
    crumbs += crumb
  end

  def file_icon(extension)
    if extension && FileTest.exists?(Rails.root.join('app','assets','images','fileicons', "#{extension.downcase}.png"))
      return image_path("fileicons/#{extension.downcase}.png")
    else
      return image_path('fileicons/unknown.png')
    end
  end

  def upload_button(folder)
    noscript_button = "#{content_tag :i, '', :class => 'icon-upload-alt icon-large'} Upload File"
    noscript_button = link_to noscript_button.html_safe, new_folder_user_file_path(folder), {
      :class => 'btn btn-large',
      :id => 'noscript-file-upload'
    }
    noscript_button = content_tag :noscript, noscript_button

    content_tag :div, noscript_button, {
      :data => {
        :'upload-action' => folder_user_files_path(folder, :format => :json),
        :'folder-html-action' => folder_path(folder),
        :'ie-progress-image-src' => image_path('loading.gif')
      }, 
      :id => 'file-uploader'
    }
  end

  def ie_upload_button(folder)
    upload_button = "#{content_tag :i, '', :class => 'icon-upload-alt icon-large'} Upload File"
    upload_button = link_to upload_button.html_safe, new_folder_user_file_path(folder), {
      :class => 'btn btn-large'
    }

    content_tag :div, upload_button, { :id => 'ie-uploads-button' }
  end

  def new_folder_button(folder)
    link_to "#{content_tag :i, '', :class => 'icon-folder-open icon-large'} New Folder".html_safe, new_folder_folder_path(folder), {
      :id => 'new-folder-button',
      :class => 'btn btn-large',
      :data => {:toggle => 'modal'}
    }
  end

  def dropdown_menu_toggle
    caret = content_tag :span, '', :class => 'caret'
    content_tag :button, caret, :class => 'btn dropdown-toggle', :data => {:toggle => 'dropdown'}
  end

  def rename_folder_menu_item(folder)
    button_text = "#{content_tag :i, '', :class => 'icon-edit icon-large'} Rename"
    link_to button_text.html_safe, "#rename-folder-modal-#{folder.id}", :data => {:toggle => 'modal'}
  end

  def delete_folder_menu_item(folder)
    button_text = "#{content_tag :i, '', :class => 'icon-trash icon-large'} Delete"
    link_to button_text.html_safe, "#delete-folder-modal-#{folder.id}", :data => {:toggle => 'modal'}
  end

end
