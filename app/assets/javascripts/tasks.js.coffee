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
  $(document).ready ->

    # get top categories
    $.ajax
      type: "POST"
      url: '/api/avito'
      data: 
        path: 'locations/top/children'
      success: (xhr) ->
        if xhr['status']
          html = "<option></option>"
          $.each xhr['result'], (i,e)-> 
            dp = DataParam(e)
            html +=  "<option val=\"#{e['id']}\" #{dp}>
                        #{e['names'][1]}
                      </option>"

          $("#avito_main_regions").html(html)
        else
          c "Get main region", "error"

    # Event it is changed main categories, []+"" 
    $("#avito_main_regions").change ->
      $('#avito_sub_regions').html("")
      id   = $('#avito_main_regions option:selected').attr('val')
      data = $('#avito_main_regions option:selected').data()
      # func (err, ok, warning,)
      c "#{id} - #{Object.keys(data).join(", ")}", "success"
      $.each data, (k,v) -> 
        $.ajax
          type: "POST"
          url: '/api/avito'
          data: 
            path: "locations/#{id}/#{k}"
          success: (xhr) ->
            if xhr['status']
              html = "<label>#{v}</label><select id=\"#{id}_#{k}\" name=\"#{k}[#{id}]\"><option></option>"
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
              c "id:#{id}, name:#{k}, count:#{count}", "success", 2


    $(document).on 'change', '#avito_sub_regions select', ->
      ids  = $(this).attr('id').split('_')
      id   = $(this).find('option:selected').attr('val')
      data = $(this).find('option:selected').data()
      $.each data, (k,v) ->
        c "parent:#{ids.join()}, id:#{id}, name:#{Object.keys(data).join(", ")}", "event"












