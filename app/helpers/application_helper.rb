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
        :class => 'alert alert-success',
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

    messages
  end

  def form_modal_tag(options = {}, &block)
    opts = {
      :id => nil,
      :success_message => 'Success',
      :class => []
    }.merge(options)

    if opts[:class].is_a? String
      opts[:class] = opts[:class].split(' ')
    end

    content_tag :div, capture(&block), {
      :class => (['modal', 'hide', 'form-modal'] << opts[:class]),
      :id => opts[:id],
      :data => {:success_message => opts[:success_message]}
    }
  end

  def confirmation_modal_tag(options = {}, &block)
    opts = {
      :id => nil,
      :class => [],
      :success_message => 'Success',
      :action => '/'
    }.merge(options)

    content_tag :div, capture(&block), {
      :class => (['modal', 'hide', 'confirmation-modal'] << opts[:class]) ,
      :id => opts[:id],
      :data => {
        :success_message => opts[:success_message],
        :action => opts[:action]
      }
    }
  end

end
