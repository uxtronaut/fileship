class window.FileShipUploader
  constructor: () ->
    if self.disableIE8()
      return
    @bindUploader()

  bindUploader: () ->

    ajax_uploader = new qq.FileUploader
      element: $('#file-uploader')[0]
      listElement: $('#alerts')[0]
      dropZone: $('#upload-drop-zone')[0]
      action: $('#file-uploader').data('upload-action')
      maxConnections: 1
      template: self.template()
      fileTemplate: self.fileDivTemplate()
      classes: self.templateClasses()
      # Maximum file size is 250MB (in bytes)
      sizeLimit: (1024 * 1024 * 250)
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

        if responseJSON.success
          self.uploadSuccess(file_div)
        else
          self.uploadError(file_div, responseJSON.errors)


  self.uploadSuccess = (file_div) ->
    $.ajax
      url: $('#file-uploader').data('folder-html-action')
      dataType: 'html'
      type: 'GET'
      success: (data)->
        $('#folder-wrapper').html(data)
        window.folder = new Folder

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
    unless errors.attachment == undefined
      message += ': File ' + errors.attachment
    return message

  self.template = () ->
    return '' +
      '<div class="uploader">' +
        '<div class="upload-button">' +
          '<a href="#" class="btn btn-large btn-">' +
            '<i class="icon-upload-alt icon-large"></i> Upload File(s)' +
          '</a>' +
        '</div>' +
      '</div>'

  self.fileDivTemplate = () ->
    return '' +
      '<div data-alert="alert" class="file-status alert alert-info">' +
        '<a class="close upload-cancel" href="#">&times;</a>' +
          '<div class="upload-file"><!-- file --></div>' +
          '<div class="upload-size"><!-- size --></div>' +
        '<div class="progress-text"><img src="'+$('#file-uploader').data('ie-progress-image-src')+'" /> Uploading...</div>' +
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
  self.disableIE8 = () ->
    if BrowserDetect.browser == "MSIE" && BrowserDetect.version < 9.0
      $('#file-uploader').hide()
      $('#ie-uploads-button').css('display', 'inline-block')
      return true
    return false