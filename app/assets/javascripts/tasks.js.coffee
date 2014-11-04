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
    $('body').addClass('loading')
    # get top categories
    $.ajax
      type: "POST"
      url: '/api/avito'
      data: 
        path: 'locations/top/children'
      success: (xhr) ->
        if xhr['status']
          html = "<option val=\"0\"></option>"
          $.each xhr['result'], (i,e)-> 
            dp = DataParam(e)
            html +=  "<option val=\"#{e['id']}\" #{dp}>
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
        $('body').removeClass('loading')
        if xhr['status']
          data_cat = xhr['result']
          html = "<option val=\"0\"></option>"
          $.each xhr['result'], (i,e)-> 
            #bugaga in => of  []+""
            unless 'parentId' of e
              dp = DataParam(e)
              html +=  "<option val=\"#{e['id']}\" #{dp}>
                          #{e['name']}
                        </option>"

          $("#avito_main_cs").html(html)
        else
          c "Get main categories", "error"

    ############################
    ## JS events for location ##
    ############################
    $("#avito_main_regions").change ->
      $('#avito_sub_regions').html("")
      id = $('#avito_main_regions option:selected').attr('val')
      if id == "0"
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
                html = "<label>#{v}</label><select id=\"#{id}_#{k}\" name=\"#{k}[#{id}]\"><option val=\"0\"></option>"
                count = 0
                $.each xhr['result'], (i,e) -> 
                  count += 1
                  dp = DataParam(e)
                  if k == 'children'
                    html  += "<option val=\"#{e['id']}\" #{dp}>#{e['names'][1]}</option>"
                  else
                    html  += "<option val=\"#{e['id']}\" #{dp}>#{e['name']}</option>"
                html += "</select>"
                $('#avito_sub_regions').append(html)
                if --cox == 0 
                  $('body').removeClass('loading')
                c "🌍 id:#{id}, name:#{k}, count:#{count}", "success", 2

    $(document).on 'change', '#avito_sub_regions select', ->
      ids  = $(this).attr('id').split('_')
      id   = $(this).find('option:selected').attr('val')
      data = $(this).find('option:selected').data()
      $.each data, (k,v) ->
        c "🌍 parent:#{ids.join()}, id:#{id}, name:#{Object.keys(data).join(", ")}", "event"


    ##############################
    ## JS events for cagerories ##
    ##############################
    $("#avito_main_cs").change ->
      $('#avito_sub_cs').html("")
      id  = $('#avito_main_cs option:selected').attr('val')
      c "🌳 category:#{id}", "event"
      if id == "0"
        $('#avito_sub_cs').prop('disabled', true)

      else
        
        html = "<option val=\"0\"></option>"
        $.each data_cat, (i,e)->
          if e['parentId'] == id
            dp    = DataParam(e)
            html +=  "<option val=\"#{e['id']}\" #{dp}>
                        #{e['name']}
                      </option>"

        $('#avito_sub_cs').html(html)
        $('#avito_sub_cs').prop('disabled', false)


    #################################
    ## JS events for subcagerories ##
    ## add params fo cat           ##
    #################################
    $("#avito_sub_cs").change ->
      id = $('#avito_sub_cs option:selected').attr('val')
      $('#avito_search_params').html("")
      if id == "0"
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

                html += "<label>#{o['title']}</label><select name=\"params[#{o['id']}]\"><option val=\"0\"></option>"
                $.each o['values'], (ii,oo) -> 
                  html += "<option val=\"#{oo['id']}\">#{oo['title']}</option>"

                html += "</select>"

              $('#avito_search_params').html(html)
              $('body').removeClass('loading')
















