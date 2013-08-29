# Fileship
# Copyright (C) 2012 Oregon State University
#
#

module ApplicationHelper

  def tophat_tag(image, url)
    link_to (image_tag image, {:class => 'tag'}), url, {:class => 'brand'} unless image.blank?
  end

  def flash_messages
    messages = ""

    notice_message = ""
    if flash[:notice]
      notice_message << content_tag(:h4, flash[:notice], :class => 'alert-heading')
      messages << content_tag(:div, notice_message.html_safe, {
        :class => 'alert alert-success',
        :id => 'notice',
        :"data-alert" => 'alert'
      })
    end

    alert_message = ""
    if flash[:alert]
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
