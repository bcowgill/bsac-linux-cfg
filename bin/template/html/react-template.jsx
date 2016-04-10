// templates/examples of React's JSX Gotchas and differences to HTML

http://snip.ly/7DTB#https://facebook.github.io/react/docs/jsx-in-depth.html#html-tags-vs.-react-components
https://facebook.github.io/react/docs/jsx-gotchas.html
https://facebook.github.io/react/docs/forms.html

React's JSX uses the upper vs. lower case convention to distinguish between
local component classes and HTML tags.

Since JSX is JavaScript, identifiers such as class and for are discouraged
as XML attribute names. Instead, React DOM components expect DOM property
names like className and htmlFor, respectively.

The Transform

React JSX transforms from an XML-like syntax into native JavaScript. XML
elements, attributes and children are transformed into arguments that are
passed to React.createElement.

var Nav;
// Input (JSX):
var app = <Nav color="blue" />;
// Output (JS):
var app = React.createElement(Nav, {color:"blue"});

JSX also allows specifying children using XML syntax:

var Nav, Profile;
// Input (JSX):
var app = <Nav color="blue"><Profile>click</Profile></Nav>;
// Output (JS):
var app = React.createElement(
  Nav,
  {color:"blue"},
  React.createElement(Profile, null, "click")
);

JSX will infer the class's displayName from the variable assignment when the
displayName is undefined:

// Input (JSX):
var Nav = React.createClass({ });
// Output (JS):
var Nav = React.createClass({displayName: "Nav", });

namespaced components let you use one component that has other components as
attributes:

var Form = MyFormComponent;

var App = (
  <Form>
    <Form.Row>
      <Form.Label />
      <Form.Input />
    </Form.Row>
  </Form>
);

Attribute Expressions

To use a JavaScript expression as an attribute value, wrap the expression in
a pair of curly braces ({}) instead of quotes ("").

// Input (JSX):
var person = <Person name={window.isLoggedIn ? window.name : ''} />;
// Output (JS):
var person = React.createElement(
  Person,
  {name: window.isLoggedIn ? window.name : ''}
);

Boolean Attributes #

Omitting the value of an attribute causes JSX to treat it as true. To pass
false an attribute expression must be used. This often comes up when using
HTML form elements, with attributes like disabled, required, checked and
readOnly.

// These two are equivalent in JSX for disabling a button
<input type="button" disabled />;
<input type="button" disabled={true} />;

// And these two are equivalent in JSX for not disabling a button
<input type="button" />;
<input type="button" disabled={false} />;

Interactive Props #

Form components support a few props that are affected via user interactions:
value, supported by <input> and <textarea> components.
checked, supported by <input> components of type checkbox or radio.
selected, supported by <option> components.

Textarea values instead of text in the child
<textarea name="description" value="This is a description." />

Child Expressions #
Likewise, JavaScript expressions may be used to express children:

// Input (JSX):
var content = <Container>{window.isLoggedIn ? <Nav /> : <Login />}</Container>;
// Output (JS):
var content = React.createElement(
  Container,
  null,
  window.isLoggedIn ? React.createElement(Nav) : React.createElement(Login)
);

Comments #

It's easy to add comments within your JSX; they're just JS expressions. You
just need to be careful to put {} around the comments when you are within
the children section of a tag.

var content = (
  <Nav>
    {/* child comment, put {} around */}
    <Person
      /* multi
         line
         comment */
      name={window.isLoggedIn ? window.name : ''} // end of line comment
    />
  </Nav>
);

HTML Entities/Unicode
WRONG: <div>First &middot; Second</div>

OK <div>{'First · Second'}</div>

use actual unicode char, save file as UTF-8 and set charset type correctly
on server config.

SAFER
<div>{'First \u00b7 Second'}</div>
<div>{'First ' + String.fromCharCode(183) + ' Second'}</div>

Mix Arrays with strings and JSX
<div>{['First ', <span>&middot;</span>, ' Second']}</div>

If you pass properties to native HTML elements that do not exist in the HTML
specification, React will not render them. If you want to use a custom
attribute, you should prefix it with data-.

<div data-custom-attribute="foo" />

However, arbitrary attributes are supported on custom elements (those with a
hyphen in the tag name or an is="..." attribute).

<x-my-component custom-attribute="foo" />
Web Accessibility attributes starting with aria- will be rendered properly.

<div aria-hidden={true} />


DOM Differences

React has implemented a browser-independent events and DOM system for
performance and cross-browser compatibility reasons. We took the opportunity
to clean up a few rough edges in browser DOM implementations.

All DOM properties and attributes (including event handlers) should be
camelCased to be consistent with standard JavaScript style. We intentionally
break with the spec here since the spec is inconsistent. However, data-* and
aria-* attributes conform to the specs and should be lower-cased only.

The style attribute accepts a JavaScript object with camelCased properties
rather than a CSS string. This is consistent with the DOM style JavaScript
property, is more efficient, and prevents XSS security holes.

Since class and for are reserved words in JavaScript, the JSX elements for
built-in DOM nodes should use the attribute names className and htmlFor
respectively, (eg. <div className="foo" /> ). Custom elements should use
class and for directly (eg. <my-tag class="foo" /> ).

All event objects conform to the W3C spec, and all events (including submit)
bubble correctly per the W3C spec. See Event System for more details.

The onChange event behaves as you would expect it to: whenever a form field
is changed this event is fired rather than inconsistently on blur. We
intentionally break from existing browser behavior because onChange is a
misnomer for its behavior and React relies on this event to react to user
input in real time. See Forms for more details.

Form input attributes such as value and checked, as well as textarea.

Potential Issues With Checkboxes and Radio Buttons #

Be aware that, in an attempt to normalize change handling for checkbox and
radio inputs, React uses a click event in place of a change event. For the
most part this behaves as expected, except when calling preventDefault in a
change handler. preventDefault stops the browser from visually updating the
input, even if checked gets toggled. This can be worked around either by
removing the call to preventDefault, or putting the toggle of checked in a
setTimeout.

Default Value #

If you want to initialize the component with a non-empty value, you can
supply a defaultValue prop. For example:

  render: function() {
    return <input type="text" defaultValue="Hello!" />;
  }
This example will function much like the Uncontrolled Components example above.

Likewise, <input type="checkbox"> and <input type="radio"> support
defaultChecked, and <select> supports defaultValue.

Note:

The defaultValue and defaultChecked props are only used during initial
render. If you need to update the value in a subsequent render, you will
need to use a controlled component.

Select / Option Lists

The selected <option> in an HTML <select> is normally specified through that
option's selected attribute. In React, in order to make components easier to
manipulate, the following format is adopted instead:

  <select value="B">
    <option value="A">Apple</option>
    <option value="B">Banana</option>
    <option value="C">Cranberry</option>
  </select>
  
To make an uncontrolled component, defaultValue is used instead.

Note:

You can pass an array into the value attribute, allowing you to select
multiple options in a select tag:

<select multiple={true} value={['B',
'C']}>.
