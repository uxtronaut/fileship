old_setting = Setting.find_by_name("Days until purge")
old_setting.update_attributes(:name => "Days until file purge") unless old_setting.blank?

Setting.seed_once(:name,
  {:name => "Days until file purge", :value => 30, :description => "The number of days before files are deleted automatically by cron. Should be an integer."},
  
  {:name => "Days until log purge", :value => 60, :description => "The number of days before file logs are deleted automatically by cron. Should be an integer."},
  
  {:name => "Logo image path",  :value => "", :description => "If you would like an image to appear in Fileship's top hat, provide the image's URL here."},
  
  {:name => "Logo url",         :value => "", :description => "If you want the aforementioned image to become a clickable link, provide the URL here."},
  
  {:name => "Policy path",      :value => "", :description => "If you have a 'terms of use' policy, provide its URL here."},
  
  {:name => "Stylesheet path",  :value => "", :description => "If you want to add custom CSS to Fileship, provide the stylesheet's URL here. For an exmaple, see EXAMPLE_STYLESHEET.css"}
)