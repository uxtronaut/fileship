module UserFilesHelper

  def sharing_button(file)
    button_text = "#{content_tag :i, '', :class => 'icon-share icon-large'} Sharing"
    link_to button_text.html_safe, "#sharing-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def password_button(file)
    button_text = "#{content_tag :i, '', :class => 'icon-lock icon-large'} Password"
    link_to button_text.html_safe, "#password-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

  def edit_file_button(file)
    button_text = "#{content_tag :i, '', :class => 'icon-edit icon-large'} Edit"
    link_to button_text.html_safe, "#edit-file-modal-#{file.id}", :data => {:toggle => 'modal'}
  end

end
