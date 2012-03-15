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

end
