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
    window.alerts.notify('create', 'success-template', {text: message})

    