$.fn.extend
  form_modal: (options) ->
    self = $.fn.form_modal
    opts = $.extend {}, self.default_options, options
    $(this).each (i, modal) ->
      self.init modal, opts

$.extend $.fn.form_modal,
  default_options:
    log: false

  init: (modal, opts) ->
    opts.empty_form = $('<div>').append($(modal).find('form').clone()).html()

    $(modal).on 'hidden', ->
      $.fn.form_modal.clean_form(modal, opts)

    $(modal).on 'shown', ->
      $(modal).find('input').focus()

    $(modal).find('form').on 'submit', ->
      $.fn.form_modal.submit_form(modal, opts)
      false

    $(modal).find('.submit').on 'click', ->
      $.fn.form_modal.submit_form(modal, opts)
      false

  submit_form: (modal, opts)->
    $(modal).find('.progress-wheel').show()
    form = $(modal).find('form')
    $.ajax 
      url: form.attr 'action'
      data: form.serializeArray()
      dataType: 'html'
      type: form.attr 'method'
      success: (data)->
        $(modal).modal('hide')
        $('#folder-wrapper').html(data)
        window.folder.initialize_modals()
      error: (response)->
        form.replaceWith(response.responseText)
        $(modal).find('form').on 'submit', ->
          $.fn.form_modal.submit_form(modal, opts)
          false
      complete: ->
        $(modal).find('.progress-wheel').hide()

  clean_form: (modal, opts) ->
    $(modal).find('form').replaceWith(opts.empty_form)

  log: (msg) ->
    console.log msg
