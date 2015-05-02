# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ -> 
  $(document).ready ->

    #form ajax
    $("#form-invite").submit (event) ->
      event.preventDefault()
      console.log event

      if $("#form-invite input[name=\"email\"]").val() < 5
        $("#alert-form-work").html("Проверьте правильность введенных данных")
        $("#alert-form-work").addClass("alert")

      else
        $.ajax
          type: "POST"
          url: $(this).attr('action')
          data: $(this).serialize()
          success: (data) ->
            $("#alert-form-work").html(data['message'])
            if data['status']
              $("#alert-form-work").removeClass("alert")
              $("#alert-form-work").addClass("success")
            else
              $("#alert-form-work").addClass("success")
              $("#alert-form-work").addClass("alert")
            return

    Dropzone.options.myAwesomeDropzone =
      paramName: 'file'
      maxFilesize: 2
      accept: (file, done) ->
        _this = this;
        console.log done

        if file.name == '123.jpg'
          alert('Назовите Файл нормально :)')
          _this.removeFile(file);
        else
          done()
        return

      init: ->
        @on 'success', (file, responseText) ->
          console.log(responseText)
          # file.previewTemplate.appendChild "<div>" + document.createTextNode(responseText['id']) + "</div>"

          return
        return


    $('#avito_posting_e_type_uniq').change (e) -> 
      if $('#avito_posting_e_type_uniq:selected').val() == 0
        console.log(0)


    
    $('.images-select').ajaxChosen {
      dataType: 'json'
      type: 'GET'
      url: '/images.json'
    }, loadingImg: 'loading.gif'
