$ ->
  window.folder = new Folder

  window.alerts = $('#alerts').notify()

  $('#new-folder-button').click ->
    $('#new-folder-modal').modal 'show'
    return false

class window.Folder
  constructor: ->
    $('.form-modal').each (i, modal) ->
      $(modal).form_modal
        success_message: $(modal).data('success-message')

    $('.confirmation-modal').each (i, modal) ->
      $(modal).confirmation_modal()

  alert: (message, type) ->
    close_button = '<div class="close" data-dismiss="alert">&times;</div>'
    alert = '<div class="alert alert-block alert-'+type+'">'+close_button+message+'</div>'
    $('#alerts').html(alert).fadeIn('fast').delay(2000).fadeOut('fast')
    