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
      maxFilesize:  3
      acceptedFiles: "image/*"
      dictDefaultMessage:  
        "Перетащите файлы для загрузки. 
        Они будут доступны во всем сервисе, а не только в текущей задаче. 
        Поэтому указывайте нормальные имена файлам для лучшего поиска."
      dictFallbackMessage: "Установите нормальный браузер."
      dictInvalidFileType: "Загружать можно только картинки"
      dictFileTooBig:      "Фото должно быть не более 3Мб"
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
          $(".images-select").append("<option value=\"#{responseText['id']}\" selected=\"selected\">#{responseText['name']}</options");
          $(".images-select").trigger("chosen:updated");
          return
        return


    $('#avito_posting_e_type_uniq').change (e) -> 
      if $('#avito_posting_e_type_uniq:selected').val() == 0
        console.log(0)


  
    $('.images-select').chosen {
      no_results_text: "Изображенния не найденны - "
      loadingImg: 'loading.gif'
    }
