$ ->
  rename_folder_modal = new RenameFolderModal

  $('#rename-folder-modal').on 'hidden', ->
    rename_folder_modal.clean_form()

  $('#rename-folder-modal').on 'shown', ->
    $(this).find('#folder_name').focus()

  $('#rename-folder-modal form').live 'submit', ->
    rename_folder_modal.rename_folder()
    false

  $('#rename-folder-button').click ->
    rename_folder_modal.rename_folder()
    false

class RenameFolderModal
  constructor: ->
    @empty_form = $('<div>').append($('#rename-folder-modal form').clone()).html()

  rename_folder: ->
    $('#rename-folder-modal .progress-wheel').show()
    form = $('#rename-folder-modal form')
    new_name = form.find('#folder_name').val()
    $.ajax 
      url: form.attr 'action'
      data: form.serializeArray()
      dataType: 'html'
      type: 'PUT'
      success: (data)->
        $('#folder-wrapper').html(data)
        $('#rename-folder-modal').modal('hide')
        $('.breadcrumb li.active').text(new_name)
      error: (response)->
        form.replaceWith(response.responseText)
      complete: ->
        $('#rename-folder-modal .progress-wheel').hide()

  clean_form: ->
    $('#rename-folder-modal form').replaceWith(@empty_form)