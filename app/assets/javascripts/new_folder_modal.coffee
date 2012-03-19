$ ->
  new_folder_modal = new NewFolderModal

  $('#new-folder-modal').on 'hidden', ->
    new_folder_modal.clean_form()

  $('#new-folder-modal').on 'shown', ->
    $(this).find('#folder_name').focus()

  $('#new-folder-modal form').live 'submit', ->
    new_folder_modal.create_folder()
    false

  $('#create-folder-button').click ->
    new_folder_modal.create_folder()
    false

class NewFolderModal
  constructor: ->
    @empty_form = $('<div>').append($('#new-folder-modal form').clone()).html()

  create_folder: ->
    $('#new-folder-modal .progress-wheel').show()
    form = $('#new-folder-modal form')
    $.ajax 
      url: form.attr 'action'
      data: form.serializeArray()
      dataType: 'html'
      type: 'POST'
      success: (data)->
        $('#folder-wrapper').html(data)
        $('#new-folder-modal').modal('hide')
      error: (response)->
        form.replaceWith(response.responseText)
      complete: ->
        $('#new-folder-modal .progress-wheel').hide()

  clean_form: ->
    $('#new-folder-modal form').replaceWith(@empty_form)