module UserFilesHelper

  def file_menu_item(text, icon, file_id)
    button_text = "#{content_tag :i, '', :class => [icon, 'icon-large']} #{text}"
    link_to button_text.html_safe, "##{text.downcase}-file-modal-#{file_id}", :data => {:toggle => 'modal'}
  end

  def link_url(file)
    "#{request.protocol}#{request.host}:#{request.port}/#{file.link_token}"
  end

end
