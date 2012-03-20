module FoldersHelper

  def breadcrumbs(folder, crumbs='', current_folder=true)
    if folder.parent && (@current_user.is_admin? || folder.parent != Folder.root)
      crumbs = breadcrumbs(folder.parent, crumbs, false) + crumbs + (content_tag :span, '/', :class => 'divider')
    end

    crumb_text = link_to_unless current_folder, folder.name, folder
    crumb = current_folder ? (content_tag :li, crumb_text, :class => 'active') : (content_tag :li, crumb_text)
    crumbs += crumb
  end

  def file_icon(extension)
    if extension && FileTest.exists?(Rails.root.join('app','assets','images','fileicons', "#{extension.downcase}.png"))
      return image_path("fileicons/#{extension.downcase}.png")
    else
      return image_path('icons/page_white.png')
    end
  end

  def upload_button(folder)
    noscript_button = "#{content_tag :i, '', :class => 'icon-upload-alt icon-large'} Upload File"
    noscript_button = link_to noscript_button.html_safe, new_folder_user_file_path(folder), {
      :class => 'btn',
      :id => 'noscript-file-upload'
    }
    noscript_button = content_tag :noscript, noscript_button

    content_tag :div, noscript_button, {
      :data => {
        :'upload-action' => folder_user_files_path(folder, :format => :json),
        :'folder-html-action' => folder_path(folder, :format => :json),
        :'ie-progress-image-src' => image_path('loading.gif')
      }, 
      :id => 'file-uploader'
    }
  end

  def new_folder_button(folder)
    link_to "#{content_tag :i, '', :class => 'icon-plus icon-large'} New Folder".html_safe, new_folder_folder_path(folder), {
      :id => 'new-folder-button',
      :class => 'btn',
      :data => {:toggle => 'modal'}
    }
  end

  def rename_folder_button(folder)
    link_to "#{content_tag :i, '', :class => 'icon-pencil icon-large'} Rename Folder".html_safe, edit_folder_path(folder), {
      :id => 'rename-folder-button',
      :class => 'btn',
      :data => {:toggle => 'modal'}
    }
  end
end
