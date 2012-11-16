###
# jQuery Dependent Selects v1.0.0
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
                   .append("<option>#{options.placeholder}</option>")
      $newSelect.insertAfter($select)
      $newSelect.hide()

    selectChange = ($select) ->
      $('select[name]').removeAttr('name')
      valName = $select.find(':selected').html()
      val = $select.val()
      select_id = $select.attr('data-dependent-id')
      clearAllSelectsByParent($select)

      if (thing = $select.attr('data-dependent-selected-id'))
        console.log thing
      
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


    prepareSelect = ($select, depth, select_id) ->
      selectedOption($select)
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
          $option.val(val).html(name[0]).attr('data-dependent-name', name[0])
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
      prepareSelect $select, 0, createSelectId()

)(jQuery)
