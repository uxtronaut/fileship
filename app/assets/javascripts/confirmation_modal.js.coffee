$.fn.extend
  confirmation_modal: (options) ->
    self = $.fn.confirmation_modal
    opts = $.extend {}, self.default_options, options
    $(this).each (i, modal) ->
      self.init modal, opts

$.extend $.fn.confirmation_modal,
  default_options:
    log: false

  init: (modal, opts) ->
    $(modal).find('.submit').on 'click', ->
      $.fn.confirmation_modal.confirmed(modal, opts)
      false

  confirmed: (modal, opts)->
    $(modal).find('.progress-wheel').show()
    action = $(modal).data('action')
    $.ajax 
      url: action
      data:
        _method: 'delete'
      dataType: 'html'
      type: 'DELETE'
      success: (data)->
        $(modal).modal('hide')
        $('#folder-wrapper').html(data)
        window.folder.initialize_modals()
      error: (response)->
        form.replaceWith(response.responseText)
      complete: ->
        $(modal).find('.progress-wheel').hide()

  log: (msg) ->
    console.log msg
