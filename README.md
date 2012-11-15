# jQuery Dependent Selects

## Overview

This is a jQuery plugin to allow multi-level select boxes that degrade gracefully.

## Demo

You can check out some demos [over here](http://simpleweb.github.com/jquery-dependent-selects)!

## Usage

Ensure you have jQuery included in your page and include the `jquery-dependent-selects.js` script by adding something like this to your page's `<head>`:

*Note: Change the `src` value to match the location of the scripts.*

```html
<script src="path/to/jquery.js"></script>
<script src="path/to/jquery-dependent-selects.js"></script>
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
  separator: ' > ', // The separator used to define the nesting in the option field's text
  placeholder: '', // The text used for the sub select boxes' placeholder option
});
```
