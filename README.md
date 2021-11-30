# jQuery Dependent Selects

## Overview

A jQuery plugin to allow multi-level select boxes that degrade gracefully. It only changes the markup so the styling is all down to you.

## Demo

You can check out some demos [over here](http://markjs.github.io/jquery-dependent-selects/)!

## Usage

Ensure you have jQuery included in your page and include the `jquery-dependent-selects.js` script by adding something like this to your page's `<head>`:

*Note: Change the `src` value to match the location of the scripts.*

```html
<script src="path/to/jquery.js"></script>
<script src="path/to/jquery.dependent-selects.js"></script>
```

Mark up your selects as you'd like them to work without JavaScript, ensuring their text displays a consistent separator. For example:

```html
<select name="location" class="dependent">
  <option></option>
  <option value="238">London > North > Enfield</option>
  <option value="239">London > North > Barnet</option>
  <option value="240">London > South > Croydon</option>
  <option value="241">London > South > Bromley</option>
  <option value="242">London > South > Sutton</option>
  <option value="243">Bristol > St Pauls</option>
  <option value="244">Bristol > Horfield</option>
  <option value="245">Bristol > Bedminster</option>
  <option value="246">Bournemouth</option>
</select>
```

Initiate the plugin on the selects you would like it to be activated:

*Note: It's best for this be done after the DOM is ready. For more info see [this brief tutorial](http://bit.ly/TxePc).*

```javascript
$('.dependent').dependentSelects();
```

**Viola!** Your select boxes should now be dependently nested.

## Customisation

There's some options you can pass into jQuery Dependent Selects when called. They are listed here showing the defaults:

```javascript
$('.example-class').dependentSelects({
  separator: ' > ', // String: The separator used to define the nesting in the option field's text
  placeholderOption: '', // String or array of strings: The text used for the sub select boxes' placeholder option.
                   // If an array, the first 'sub' level will be the first array item, you should manually create
                   // the top level's placeholder in the HTML.
  placeholderValue: '',  // String or array of strings: The value used for the sub select boxes' placeholder option.
  placeholderSelect: false, // Array of strings: The text used for placeholder select boxes for sub levels.
  class: false, // String: Add an extra class to all sub selects
  labels: false // Array of strings: The text used for the sub select boxes' labels. Label element is
                // inserted before sub select.
});
```

## Contributing

The plugin is written in CoffeeScript and a Cakefile is included with `build` and `watch` tasks. If you'd like to contribute, please write CoffeeScript and use the Cake tasks to compile it.

1. Fork project
2. Checkout to a new branch (named after the feature / change you're making)
3. Write code (as mentioned above)
4. Submit pull request

## License

Licenced under MIT. Copyright Mark J Smith, Simpleweb.
