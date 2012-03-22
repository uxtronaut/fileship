$ ->
  window.folder = new Folder

  $('#new-folder-button').click ->
    $('#new-folder-modal').modal 'show'
    return false


class window.Folder
  constructor: ->
    @initialize_modals()

  initialize_modals: ->
    $('.form-modal').each (i, modal) ->
      $(modal).form_modal()

    $('.confirmation-modal').each (i, modal) ->
      $(modal).confirmation_modal()