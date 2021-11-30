###
# jQuery Dependent Selects v1.2.3
# Copyright 2012 Mark J Smith, Simpleweb
# Licenced under MIT
# Details on http://github.com/simpleweb/jquery-dependent-selects
###

(($) ->

  $.fn.dependentSelects = (options = {}) ->
    options = $.extend({
      'separator': ' > '
      'placeholderOption': ''
      'placeholderValue': ''
      'placeholderSelect': false
      'class': false
      'labels': false
    }, options)

    createSelectId = ->
      # Yeah, it'll fall down if you have more than 1000 of these on a page.
      # But if you're doing that, then you should go outside and breathe some fresh air.
      int = parseInt(Math.random()*1000)
      if $("[data-dependent-id='#{int}']").length > 0
        createSelectId()
      else
        int

    splitName = ($name) ->
      array = $.map($name.split(options.separator), (valuePart) -> $.trim(valuePart))
      i = 0
      for item in array
        if item == ''
          array.splice(i, 1)
          i--
        i++
      array
      
    splitOptionName = ($option) ->
      splitName($option.text())

    

    placeholderSelectAtDepth = (depth, $select) ->
      depth--
      placeholder = options.placeholderSelect
      if placeholder
        if placeholder == true
          placeholder = $select.data('dependent-select-placeholders')
        if typeof placeholder == 'object'
          if placeholder[depth]
            text = placeholder[depth]
          else
            text = placeholder[placeholder.length-1]
        else
          text = placeholder
        $("<select disabled><option>#{text}</option></select>").attr({
          'data-dependent-depth': depth+1
          'data-dependent-placeholder': true
          'data-dependent-id': $select.attr('data-dependent-id')
        })

    placeholderOptionAtDepth = (depth) ->
      depth--
      placeholder = options.placeholderOption
      if typeof placeholder == 'object'
        if placeholder[depth]
          text = placeholder[depth]
        else
          text = placeholder[placeholder.length-1]
      else
        text = placeholder

      def_val = options.placeholderValue
      if typeof def_val == 'object'
        if def_val[depth]
          val = def_val[depth]
        else
          val = def_val[def_val.length-1]
      else
        val = def_val
      if val != null && val != ''
        val = ' value="' + val + '"';
      
      $("<option#{val}>#{text}</option>")

    labelAtDepth = (depth, $select) ->
      depth--
      labels = options.labels
      if labels
        if labels == true
          labels = $select.data('dependent-labels')
        if labels[depth]
          labels[depth]
        else
          labels[labels.length-1]
      else
        false

    hideSelect = ($select) ->
      select_id = $select.attr('data-dependent-id')
      select_depth = $select.attr('data-dependent-depth')
      placeholder_select = $("select[data-dependent-placeholder][data-dependent-id='#{select_id}'][data-dependent-depth='#{select_depth}']")
      label = $("label[data-dependent-id='#{select_id}'][data-dependent-depth='#{select_depth}']").hide()
      if placeholder_select.length > 0
        placeholder_select.show()
        label.show()

      $select.hide()

    showSelect = ($select) ->
      select_id = $select.attr('data-dependent-id')
      select_depth = $select.attr('data-dependent-depth')
      placeholder_select = $("select[data-dependent-placeholder][data-dependent-id='#{select_id}'][data-dependent-depth='#{select_depth}']")
      label = $("label[data-dependent-id='#{select_id}'][data-dependent-depth='#{select_depth}']").show()
      if placeholder_select.length > 0
        placeholder_select.hide()

      $select.show()

    insertLabel = ($select, $parent) ->
      if label = labelAtDepth($select.attr('data-dependent-depth'), $select)
        select_id = $select.attr('data-dependent-id')
        select_depth = $select.attr('data-dependent-depth')
        $label = $("<label>#{label}</label>").attr({
          'data-dependent-id': select_id
          'data-dependent-depth': select_depth
        })
        unless $("label[data-dependent-id='#{select_id}'][data-dependent-depth='#{select_depth}']").length > 0
          if $parent
            $parent.after($label)
          else
            $select.before($label)

    insertPlaceholderSelect = ($select) ->
      if $placeholderSelect = placeholderSelectAtDepth($select.attr('data-dependent-depth'), $select)
        select_id = $select.attr('data-dependent-id')
        depth = $select.attr('data-dependent-depth')
        unless $("select[data-dependent-placeholder][data-dependent-id='#{select_id}'][data-dependent-depth='#{depth}']").length > 0
          $select.before($placeholderSelect)

    clearAllSelectsByParent = ($parent) ->
      $(".dependent-sub[data-dependent-id='#{$parent.attr('data-dependent-id')}']").each ->
        if parseInt($(@).attr('data-dependent-depth')) > parseInt($parent.attr('data-dependent-depth'))
          $(@).find('option:first').prop('selected', true)
          hideSelect $(@)

    createNewSelect = (name, $select, depth) ->
      select_id = $select.attr('data-dependent-id')
      path = pathForOption($select, name)

      if ($currentSelect = $("select[data-dependent-path='#{path}'][data-dependent-id='#{select_id}']")).length > 0
        return $currentSelect

      $newSelect = $('<select class="dependent-sub"/>')
                   .attr('data-dependent-depth', depth)
                   .attr('data-dependent-input-name', $select.attr('data-dependent-input-name'))
                   .attr('data-dependent-id', select_id)
                   .addClass(options.class)
                   .append(placeholderOptionAtDepth(depth))

      if options.labels == true
        $newSelect.attr('data-dependent-labels', $select.attr('data-dependent-labels'))

      if options.placeholderSelect == true
        $newSelect.attr('data-dependent-select-placeholders', $select.attr('data-dependent-select-placeholders'))

      if ($labels = $("label[data-dependent-id='#{select_id}'][data-dependent-depth='#{depth}']")).length > 0
        $newSelect.insertAfter($labels)
      else
        $newSelect.insertAfter($select)
        
      insertLabel($newSelect, $select)
      insertPlaceholderSelect($newSelect)
      hideSelect($newSelect)

    selectChange = ($select) ->
      $("select[data-dependent-id='#{$select.attr('data-dependent-id')}'][name]").removeAttr('name')
      valName = $select.find(':selected').html()
      val = $select.val()
      select_id = $select.attr('data-dependent-id')
      clearAllSelectsByParent($select)

      path = pathForOption($select, valName).replace("'", "\\'")
      if ($sub = $(".dependent-sub[data-dependent-path='#{path}'][data-dependent-id='#{select_id}']")).length > 0
        showSelect $sub
        $sub.attr('name', $select.attr('data-dependent-input-name'))
      else
        $select.attr('name', $select.attr('data-dependent-input-name'))

    selectedOption = ($select) ->
      $selectedOption = $select.find('option:selected')
      val = $selectedOption.val()
      unless val == '' or val == placeholderOptionAtDepth($select.attr('data-dependent-depth')).val()
        $select.attr('data-dependent-selected-id', val)

    findSelectParent = ($select) ->
      $selects = $("select[data-dependent-id='#{$select.attr('data-dependent-id')}']")
      $all_options = $selects.find('option')

      $selects.filter( ->
        vals = []
        $(@).find('option').each ->
          vals.push $(@).attr('data-dependent-path') == $select.attr('data-dependent-path')
        $.inArray(true, vals) > -1
      )

    pathForOption = ($select, $name) ->
      if $select.attr('data-dependent-depth') == '0'
        $name
      else
        $select.attr('data-dependent-path') + options.separator + $name

    selectPreSelected = ($select) ->
      if (selected_id = $select.attr('data-dependent-selected-id'))
        $selects = $("select[data-dependent-id='#{$select.attr('data-dependent-id')}']")
        $all_options = $selects.find('option')

        $selected_option = $all_options.filter("[value='#{selected_id}']")
        $selected_select = $selected_option.closest('select')

        $current_select = $selected_select
        current_option_text = $selected_option.html()

        for i in [(parseInt $selected_select.attr('data-dependent-depth'))..0]
          $current_select.find('option').each ->
            if $(@).html() == current_option_text
              $(@).prop('selected', true)
            else
              $(@).prop('selected', false)
          
          showSelect $current_select
          if typeof($current_select.attr('data-dependent-path')) != "undefined"
            current_option_text = splitName($current_select.attr('data-dependent-path')).slice(-1)[0];
            $current_select = findSelectParent($current_select)

        $selected_select.trigger('change')

    prepareSelect = ($select, depth, select_id) ->
      $select.attr('data-dependent-depth', depth).attr('data-dependent-id', select_id)
      $options = $select.children('option')
      $options.each ->
        $option = $(@)
        
        name = splitOptionName($option)
        val = $option.val()
        if name.length > 1
          # Create sub select
          $subSelect = createNewSelect(htmlEncode(name[0]), $select, depth + 1)
          path = pathForOption($select, name[0])
          $subSelect.attr('data-dependent-path', path)
          # Copy option into sub select
          $newOption = $option.clone()
          $newOption.html($.trim(splitOptionName($newOption)[1..-1].join(options.separator)))
          $subSelect.append($newOption)

          # Change option to just parent location
          
          $option.val('').html(name[0]).attr('data-dependent-path', path)
          # Remove option if already one for that parent location
          $option.remove() if $options.parent().find("[data-dependent-path='#{path}']").length > 1

          prepareSelect($subSelect, depth + 1, select_id)

      name = $select.attr('name')

      selectChange($select)

      $select.off('change').on 'change', ->
        selectChange($select)

    htmlEncode = (value) ->
      $('<div/>').text(value).html();

    # Loop through each of the selects the plugin is called on, and set them up!
    @each ->
      $select = $(@)
      $select.attr('data-dependent-input-name', $select.attr('name'))
      selectedOption($select)
      
      prepareSelect $select, 0, createSelectId()
      selectPreSelected($select)

)(jQuery)
