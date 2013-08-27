$(document).ready(function(){  
  var user_select = $('#user_id');
  var promote = $('#promote');
  promote.hide();
  
  user_select.on("change", function() {
    if(user_select.val() == "") {
      promote.hide();
    }
    else {
      promote.show();
    }
  });
});