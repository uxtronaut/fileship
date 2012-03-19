class window.FileShipUploader
  constructor: () ->
    if self.disableIE7()
      return
    @bindUploader()

  bindUploader: () ->

    ajax_uploader = new qq.FileUploader
      element: $('#file-uploader')[0]
      listElement: $('#uploads-list')[0]
      dropZone: $('#upload-drop-zone')[0]
      action: $('#file-uploader').data('upload-action')
      maxConnections: 1
      template: self.template()
      fileTemplate: self.fileDivTemplate()
      classes: self.templateClasses()
      params:
        'authenticity_token': $('meta[name="csrf-token"]').attr('content')

      onProgress: (id, fileName, loaded, total) ->
        # Set the progress bar percent
        file_div = ajax_uploader._getItemByFileId(id)
        $(file_div).find('.progress-wrapper').show()
        $(file_div).find('.progress-text').hide()
        $(file_div).find('.progress-bar').css('width', Math.round(loaded / total * 100) + '%')

      onComplete: (id, fileName, responseJSON) ->
        # Remove the progress bar and add the close X to the file div
        file_div = ajax_uploader._getItemByFileId(id)
        $(file_div).find('.progress-wrapper').remove()
        $(file_div).prepend('<a class="close" title="close" data-dismiss="alert" href="#">&times;</a>')

        if responseJSON.success
          self.uploadSuccess(file_div)
        else
          self.uploadError(file_div, responseJSON.errors)


  self.uploadSuccess = (file_div) ->
    $.get $('#file-uploader').data('folder-html-action'), (data) ->
      $('#folder-wrapper').html(data)
    , 'html'

    # Update file div with success class and message, set fadeout
    $(file_div).find('.progress-text').hide()
    $(file_div).removeClass('alert-info').addClass('alert-success')
    $(file_div).append('<p class="upload-status">Upload complete</p>')
    $(file_div).delay(3000).fadeOut('slow')

  self.uploadError = (file_div, errors) ->
    # Make the error messages human readable
    error_message = self.parseErrors(errors)

    # Update the file div with error class and message
    $(file_div).find('.progress-text').hide()
    $(file_div).removeClass('alert-info').addClass('alert-error')
    $(file_div).append('<p class="upload-status">'+error_message+'</p>')

  self.parseErrors = (errors) ->
    message = 'Upload failed'
    unless errors.attachment_file_name == undefined
      message += ': File ' + errors.attachment_file_name
    return message

  self.template = () ->
    return '' +
      '<div class="uploader">' +
        '<div class="upload-button">' +
          '<a href="#" class="btn">' +
            '<i class="icon-upload-alt icon-large"></i> Upload File(s)' +
          '</a>' +
        '</div>' +
      '</div>'

  self.fileDivTemplate = () ->
    return '' +
      '<div data-alert="alert" class="file-status alert alert-info">' +
        '<a class="upload-cancel btn small" href="#">Cancel</a>' +
        '<p>' +
          '<span class="upload-file"><!-- file --></span>' +
          '<span class="upload-size"><!-- size --></span>' +
        '</p>' +
        '<div class="progress-text"><img src="'+$('#file-uploader').data('ie-progress-image-src')+'"> Uploading...</div>' +
        '<div class="progress-wrapper">' +
          '<div class="progress-bar"></div>' +
        '</div>' +
      '</div>'

  self.templateClasses = () ->
    return {
      button: 'upload-button'
      drop: 'upload-drop-area'
      dropActive: 'upload-drop-area-active'
      list: 'uploads-list'
      file: 'upload-file'
      size: 'upload-size'
      cancel: 'upload-cancel'
      success: 'success'
      fail: 'error'
    }

  # Show upload link for IE users
  self.disableIE7 = () ->
    if $.browser.msie && $.browser.version < 8.0
      $('#file-uploader').hide()
      $('#ie-uploads-button').css('display', 'inline-block')
      return true
    return false