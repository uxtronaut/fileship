module ApplicationHelper

  def tophat_tag
    link_to (image_tag 'http://oregonstate.edu/osuhomepage/regions/top-hat/1.2/images/osu-tag.gif', {
      :alt => 'Oregon State University',
      :class => 'tag'
    }), 'http://oregonstate.edu/', {
      :title => 'Oregon State University',
      :class => 'brand'
    }
  end

  def flash_messages
    messages = ""

    notice_message = ""
    if flash[:notice]
      notice_message << link_to('&times;'.html_safe, nil, :class => 'close', :data => {:dismiss => 'alert'})
      notice_message << content_tag(:h4, flash[:notice], :class => 'alert-heading')
      messages << content_tag(:div, notice_message.html_safe, {
        :class => 'alert alert-info',
        :id => 'notice',
        :"data-alert" => 'alert'
      })
    end

    alert_message = ""
    if flash[:alert]
      alert_message << link_to('&times;'.html_safe, nil, :class => 'close', :data => {:dismiss => 'alert'})
      alert_message << content_tag(:h4, flash[:alert], :class => 'alert-heading')
      messages << content_tag(:div, alert_message.html_safe, {
        :class => 'alert alert-error',
        :id => 'alert'
      })
    end

    return messages.html_safe
  end

end
