#####################
c=(log, status, m) ->
  m = (if typeof m isnt "undefined" then m * 10 else 10)
  switch status
    when 'success'
      css = " background: #000; 
              border-left: #{m}px solid #1A5E25;
              color: #1A5E25; 
              padding-left:10px; 
              display:block"
    when 'error'
      css = " background: #000; 
              border-left: #{m}px solid #B00; 
              color: #B00; 
              padding-left:10px; 
              display:block"

    when 'event'
      css = " background: #000; 
              border-left: #{m}px solid #FB1; 
              color: #FB1; 
              padding-left:10px; 
              display:block"
    when 'dev'
      css = ""

    when 'bottom'
      css = " border-bottom: 4px solid #999; 
              display:block"             

  console.log "%c#{log}", css

################
DataParam=(e) -> 
  data = ""
  if e['hasChildren']
    data += "data-children=\"Подкатегория\" "
  if e['hasMetro']
    data += "data-metro=\"Метро\" "
  if e['hasDirections']
    data += "data-directions=\"Направление\" " 
  if e['hasDistricts']
    data += "data-districts=\"Район\" "
  data   
    
  

$ ->
  ###########################
  ## JS start loading page ##
  ###########################
  $(document).ready ->
    $(this).foundation('reflow')


    if $('#avito-dash').html() == "ok"
      $('body').addClass('loading')
      # get top categories
      $.ajax
        type: "POST"
        url: '/api/avito'
        data: 
          path: 'locations/top/children'
        success: (xhr) ->
          if xhr['status']
            html = "<option value=\"\"></option>"
            $.each xhr['result'], (i,e)-> 
              dp = DataParam(e)
              html +=  "<option value=\"#{e['id']}\" #{dp}>
                          #{e['names'][1]}
                        </option>"

            $("#avito_main_regions").html(html)
          else
            c "Get main region", "error"

      data_cat = null
      $.ajax
        type: "POST"
        url: '/api/avito'
        data: 
          path: 'categories'
        success: (xhr) ->

          if xhr['status']
            data_cat = xhr['result']
            html = "<option value=\"\"></option>"
            $.each xhr['result'], (i,e)-> 
              #bugaga in => of  []+""
              unless 'parentId' of e
                dp = DataParam(e)
                html +=  "<option value=\"#{e['id']}\" #{dp}>
                            #{e['name']}
                          </option>"

            $("#avito_main_cs").html(html)
          else
            c "Get main categories", "error"

          $('body').removeClass('loading')
          $(document).foundation('reflow')

    ############################
    ## JS events for location ##
    ############################
    $("#avito_main_regions").change ->
      $('#avito_sub_regions').html("")
      id = $('#avito_main_regions option:selected').val()
      if id == ""
        #??
      else
        data = $('#avito_main_regions option:selected').data()
        # func (err, ok, warning,)
        c "🌍 #{id}:#{Object.keys(data).join(", ")}", "event"
        $('body').addClass('loading')
        cox=Object.keys(data).length
        $.each data, (k,v) -> 
          $.ajax
            type: "POST"
            url: '/api/avito'
            data: 
              path: "locations/#{id}/#{k}"
            success: (xhr) ->
              if xhr['status']
                if k == 'children'
                  k = 'location'
                html = "<label>#{v}</label><select id=\"#{}_#{k}\" name=\"task[p][#{k}Id]\"><option value=\"\"></option>"
                count = 0
                $.each xhr['result'], (i,e) -> 
                  count += 1
                  dp = DataParam(e)
                  if k == 'location'
                    html  += "<option value=\"#{e['id']}\" #{dp}>#{e['names'][1]}</option>"
                  else
                    html  += "<option value=\"#{e['id']}\" #{dp}>#{e['name']}</option>"
                html += "</select>"
                $('#avito_sub_regions').append(html)
                if --cox == 0 
                  $('body').removeClass('loading')
                c "🌍 id:#{id}, name:#{k}, count:#{count}", "success", 2

    $(document).on 'change', '#avito_sub_regions select', ->
      ids  = $(this).attr('id').split('_')
      id   = $(this).find('option:selected').val()
      data = $(this).find('option:selected').data()
      $.each data, (k,v) ->
        c "🌍 parent:#{ids.join()}, id:#{id}, name:#{Object.keys(data).join(", ")}", "event"


    ##############################
    ## JS events for cagerories ##
    ##############################
    $("#avito_main_cs").change ->
      $('#avito_sub_cs').html("")
      id  = $('#avito_main_cs option:selected').val()
      c "🌳 category:#{id}", "event"
      if id == ""
        $('#avito_sub_cs').prop('disabled', true)

      else
        
        html = "<option value=\"0\"></option>"
        $.each data_cat, (i,e)->
          if e['parentId'] == id
            dp    = DataParam(e)
            html +=  "<option value=\"#{e['id']}\" #{dp}>
                        #{e['name']}
                      </option>"

        $('#avito_sub_cs').html(html)
        $('#avito_sub_cs').prop('disabled', false)


    #################################
    ## JS events for subcagerories ##
    ## add params fo cat           ##
    #################################
    $("#avito_sub_cs").change ->
      id = $('#avito_sub_cs option:selected').val()
      $('#avito_search_params').html("")
      if id == ""
        #
      else
        c "🌳 subcategory:#{id}", "event"
        $('body').addClass('loading')
        $.ajax
          type: "POST"
          url: '/api/avito'
          data: 
            path: "categories/#{id}/params/search"
          success: (xhr) ->      
            if xhr['status']
              html = ""
              $.each xhr['result'], (i,o) ->
                if o['type'] != 'select'
                  console.log o

                html += "<label>#{o['title']}</label><select name=\"task[p][params][#{o['id']}]\"><option value=\"\"></option>"
                $.each o['values'], (ii,oo) -> 
                  html += "<option value=\"#{oo['id']}\">#{oo['title']}</option>"

                html += "</select>"

              $('#avito_search_params').html(html)
              $('body').removeClass('loading')

    ###########################
    ## JS start loading page ##
    ###########################
    $('#bnt-test-task').click (e)->
      $('body').addClass('loading')
      $.ajax
        type: "POST"
        url: '/api/avito'
        data: 
          $('form#new_task').serialize()
        success: (xhr) ->
          if xhr['status'] 
            html = "<p>Найденно – #{xhr['result']['count']} обьявлений.</p>
                    <div class=\"row\" data-equalizer=\"\">"
            $.each xhr['result']['items'], (i,o) ->

              if 'price' of o

                if typeof o['price']['title'] == "object"
                  title = "#{o['price']['title']['full']}"
                else 
                  title = "#{o['price']['title']}"

                price = "#{title}: #{o['price']['value']} #{o['price']['metric']}"
              else
                price = "не указанна"

              if 'images' of o
                image = "<img src=\"#{o['images']['main']['100x75']}\">"
              else
                image = "<img src=\"#\">"


              html += "
                <div class=\"large-12 columns panel\" data-equalizer-watch=\"\">
                  <div class=\"row\">
                    <div class=\"large-3 columns\">
                      <a class=\"th radius\" href=\"http://avito.ru/#{o['id']}\" target=\"_blank\">
                        #{image}
                      </a>
                    </div>
                    <div class=\"large-9 columns\">
                      #{o['title']}
                      <br />
                      <b>
                        #{price}
                      </b>
                    </div>
                  </div>
                </div>
              "
            html += "</div>"
            $('#avito_search_result').html(html)
            $('#task_submit').prop('disabled', false)  
          else
            $('#agnid').html(
              '
                <div data-alert class="alert-box alert radius">
                  По Вашему запросу ничего не найдено.
                  <a href="#" class="close">&times;</a>
                </div>
              ')
          $('body').removeClass('loading')
          $(document).foundation('reflow')
      return false

    #hask for data-slider 
    $('.range-slider').on 'change.fndtn.slider', (e)-> 
      min = $(this).attr('data-slider')
      $('#avito_interval').html(min)

    $('#new_task').submit -> 
      $('body').addClass('loading')
      $.ajax
        type: "POST"
        url: $(this).attr('action')
        data: $(this).serialize()
        success: (xhr) ->
          if xhr['status']
            $('#agnid').html(
              "
                <div data-alert class=\"alert-box success radius\">
                  Задача под номером #{xhr['result']['id']} сохранена.<br />
                  Посмотреть памаметры можно <a href=\"/tasks/#{xhr['result']['id']}\">здесь</a>.

                  <a href=\"#\" class=\"close\">&times;</a>
                </div>
              ")
          else
            $('#agnid').html(
              "
                <div data-alert class=\"alert-box alert radius\">
                  Проверьте введенные поля.
                  <a href=\"#\" class=\"close\">&times;</a>
                </div>
              ")
          

          $('body').removeClass('loading')
          $(document).foundation('reflow')


      return false




