###
# jQuery Dependent Selects v1.0.4
# Copyright 2012 Mark J Smith, Simpleweb
# Details on http://github.com/simpleweb/jquery-dependent-selects
###

(($) ->

  $.fn.dependentSelects = (options = {}) ->
    options = $.extend({
      'separator': ' > '
      'placeholder': ''
      'class': false
    }, options)

    createSelectId = ->
      # Yeah, it'll fall down if you have more than 1000 of these on a page.
      # But if you're doing that, then you should go outside and breathe some fresh air.
      int = parseInt(Math.random()*1000)
      if $("[data-dependent-id='#{int}']").length > 0
        createSelectId()
      else
        int

    splitOptionName = ($option) ->
      array = $option.text().split(options.separator).map((valuePart) -> valuePart.trim())
      i = 0
      for item in array
        if item == ''
          array.splice(i, 1)
          i--
        i++
      array

    placeholderAtDepth = (depth) ->
      depth--
      placeholder = options.placeholder
      if typeof placeholder == 'object'
        if placeholder[depth]
          placeholder[depth]
        else
          placeholder[placeholder.length]
      else
        placeholder

    clearAllSelectsByParent = ($parent) ->
      $(".dependent-sub[data-dependent-id='#{$parent.attr('data-dependent-id')}']").each ->
        if parseInt($(@).attr('data-dependent-depth')) > parseInt($parent.attr('data-dependent-depth'))
          $(@).find('option:first').attr('selected', 'selected')
          $(@).hide()

    createNewSelect = (options = {}) ->
      name = options.name
      $select = options.select
      select_id = $select.attr('data-dependent-id')

      if ($currentSelect = $("select[data-dependent-parent='#{name}'][data-dependent-id='#{select_id}']")).length > 0
        return $currentSelect

      $newSelect = $('<select class="dependent-sub"/>').attr('data-dependent-parent', name)
                   .attr('data-dependent-depth', options.depth)
                   .attr('data-dependent-input-name', $select.attr('data-dependent-input-name'))
                   .attr('data-dependent-id', select_id)
                   .addClass(options.class)
                   .append("<option>#{placeholderAtDepth(options.depth)}</option>")
      $newSelect.insertAfter($select)
      $newSelect.hide()

    selectChange = ($select) ->
      $("select[data-dependent-id='#{$select.attr('data-dependent-id')}'][name]").removeAttr('name')
      valName = $select.find(':selected').html()
      val = $select.val()
      select_id = $select.attr('data-dependent-id')
      clearAllSelectsByParent($select)
      
      if ($sub = $(".dependent-sub[data-dependent-parent='#{valName}'][data-dependent-id='#{select_id}']")).length > 0
        $sub.show()
        $sub.attr('name', $select.attr('data-dependent-input-name'))
      else
        $select.attr('name', $select.attr('data-dependent-input-name'))

    selectedOption = ($select) ->
      $selectedOption = $select.find('option:selected')
      val = $selectedOption.val()
      unless val == '' or val == options.placeholder
        $select.attr('data-dependent-selected-id', val)

    findSelectParent = ($select) ->
      $selects = $("[data-dependent-id='#{$select.attr('data-dependent-id')}']")
      $all_options = $selects.find('option')

      $selects.filter( ->
        vals = []
        $(@).find('option').each ->
          vals.push $(@).html() == $select.attr('data-dependent-parent')
        $.inArray(true, vals) > -1
      )

    selectPreSelected = ($select) ->
      if (selected_id = $select.attr('data-dependent-selected-id'))
        $selects = $("[data-dependent-id='#{$select.attr('data-dependent-id')}']")
        $all_options = $selects.find('option')

        $selected_option = $all_options.filter("[value='#{selected_id}']")
        $selected_select = $selected_option.closest('select')

        $current_select = $selected_select
        current_option_text = $selected_option.html()

        for i in [(parseInt $selected_select.attr('data-dependent-depth'))..0]
          $current_select.find('option').each ->
            if $(@).html() == current_option_text
              $(@).attr('selected', 'selected')
            else
              $(@).removeAttr('selected')

          $current_select.show()
          current_option_text = $current_select.attr('data-dependent-parent')
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
          $subSelect = createNewSelect({ name: name[0], select: $select, depth: depth + 1, placeholder: options.placeholder, class: options.class })
          # Copy option into sub select
          $newOption = $option.clone()
          $newOption.html(splitOptionName($newOption)[1..-1].join(options.separator).trim())
          $subSelect.append($newOption)

          # Change option to just parent location
          $option.val('').html(name[0]).attr('data-dependent-name', name[0])
          # Remove option if already one for that parent location
          $option.remove() if $options.parent().find("[data-dependent-name='#{name[0]}']").length > 1

          prepareSelect($subSelect, depth + 1, select_id)

      name = $select.attr('name')

      selectChange($select)

      $select.off('change').on 'change', ->
        selectChange($select)

    # Loop through each of the selects the plugin is called on, and set them up!
    @each ->
      $select = $(@)
      $select.attr('data-dependent-input-name', $select.attr('name'))
      selectedOption($select)
      prepareSelect $select, 0, createSelectId()
      selectPreSelected($select)

)(jQuery)
