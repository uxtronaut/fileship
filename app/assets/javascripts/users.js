$(document).ready(function(){  
  var user_select = $('#user_id');
  var promote = $('#promote');
    
  user_select.change(function() {validate_selection() });
  user_select.keyup(function() {validate_selection()} );
  
  function validate_selection() {
    if (user_select.val() == "") {
      promote.prop("disabled", "true");
    }
    else {
      promote.removeProp("disabled");
    }
  }
});