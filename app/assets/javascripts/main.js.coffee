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

