module UserFilesHelper

  def share_menu_item(file)
    button_text = "#{content_tag :i, '', :class => 'icon-share icon-large'} Share"
    link_to button_text.html_safe, "#share-file-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def password_menu_item(file)
    button_text = "#{content_tag :i, '', :class => 'icon-lock icon-large'} Password"
    link_to button_text.html_safe, "#password-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def rename_file_menu_item(file)
    button_text = "#{content_tag :i, '', :class => 'icon-edit icon-large'} Rename"
    link_to button_text.html_safe, "#rename-file-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def replace_file_menu_item(file)
    button_text = "#{content_tag :i, '', :class => 'icon-repeat icon-large'} Replace"
    link_to button_text.html_safe, "#replace-file-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def delete_file_menu_item(file)
    button_text = "#{content_tag :i, '', :class => 'icon-trash icon-large'} Delete"
    link_to button_text.html_safe, "#delete-file-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def link_url(file)
    "#{request.host}:#{request.port}/#{file.link_token}"
  end
    

end
