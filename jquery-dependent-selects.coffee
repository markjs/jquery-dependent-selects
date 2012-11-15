(($) ->

  $.fn.dependentSelects = (options = {}) ->
    options = $.extend({
      'separator': ' > '
      'form': $(@).closest('form')
    }, options)

    splitOptionName = ($option) ->
      _.without($option.text().split(options['separator']).map((valuePart) -> valuePart.trim()), '')

    clearAllSelectsByParent = ($parent) ->
      $(".dependent-sub[data-dependent-input-name='#{$parent.attr('data-dependent-input-name')}']").each ->
        if parseInt($(@).attr('data-dependent-depth')) > parseInt($parent.attr('data-dependent-depth'))
          $(@).find('option:first').attr('selected', 'selected')
          $(@).hide()

    createNewSelect = (options = {}) ->
      name = options['name']
      $select = options['select']

      if ($currentSelect = $("select[data-dependent-parent='#{name}']")).length > 0
        return $currentSelect

      $newSelect = $('<select class="dependent-sub"/>').attr('data-dependent-parent', name)
                   .attr('data-dependent-depth', options['depth'])
                   .attr('data-dependent-input-name', $select.attr('data-dependent-input-name'))
                   .append('<option/>')
      $newSelect.insertAfter($select)
      $newSelect.hide()

    prepareSelect = ($select, $form, depth) ->
      $select.attr('data-dependent-depth', depth)
      $options = $select.children('option')
      $options.each ->
        $option = $(@)
        
        name = splitOptionName($option)
        val = $option.val()
        if name.length > 1
          # Create sub select
          $subSelect = createNewSelect({ name: name[0], select: $select, depth: depth + 1 })
          # Copy option into sub select
          $newOption = $option.clone()
          $newOption.html(splitOptionName($newOption)[1..-1].join(options['separator']).trim())
          $subSelect.append($newOption)

          # Change option to just parent location
          $option.val(val).html(name[0]).attr('data-dependent-name', name[0])
          # Remove option if already one for that parent location
          $option.remove() if $options.parent().find("[data-dependent-name='#{name[0]}']").length > 1

          prepareSelect($subSelect, options['form'], depth + 1)
 
      name = $select.attr('name')

      $select.off('change').on 'change', ->
        $('select[name]').removeAttr('name')
        valName = $select.find(':selected').html()
        val = $select.val()
        clearAllSelectsByParent($select)
        # $(".dependent-sub[data-dependent-depth=#{$select.data('dependent-depth')+1}]").hide().removeAttr('name')
        
        if ($sub = $(".dependent-sub[data-dependent-parent='#{valName}']")).length > 0
          $sub.show()
          $sub.attr('name', $select.attr('data-dependent-input-name'))
        else
          $select.attr('name', $select.attr('data-dependent-input-name'))

    # Loop through each of the selects the plugin is called on, and set them up!
    @each ->
      $select = $(@)
      $select.attr('data-dependent-input-name', $select.attr('name'))
      prepareSelect $select, options['form'], 0

)(jQuery)
