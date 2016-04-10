// Events for React components
// https://facebook.github.io/react/docs/events.html#form-events

Supported Events

React normalizes events so that they have consistent properties across
different browsers.

The event handlers below are triggered by an event in the bubbling phase. To
register an event handler for the capture phase, append Capture to the event
name; for example, instead of using onClick, you would use onClickCapture to
handle the click event in the capture phase.

Clipboard Events
Event names:

onCopy onCut onPaste
Properties:

DOMDataTransfer clipboardData
Composition Events
Event names:

onCompositionEnd onCompositionStart onCompositionUpdate
Properties:

string data
Keyboard Events
Event names:

onKeyDown onKeyPress onKeyUp
Properties:

boolean altKey
number charCode
boolean ctrlKey
boolean getModifierState(key)
string key
number keyCode
string locale
number location
boolean metaKey
boolean repeat
boolean shiftKey
number which
Focus Events
Event names:

onFocus onBlur
Properties:

DOMEventTarget relatedTarget
Form Events
Event names:

onChange onInput onSubmit
For more information about the onChange event, see Forms.

Mouse Events
Event names:

onClick onContextMenu onDoubleClick onDrag onDragEnd onDragEnter onDragExit
onDragLeave onDragOver onDragStart onDrop onMouseDown onMouseEnter onMouseLeave
onMouseMove onMouseOut onMouseOver onMouseUp

The onMouseEnter and onMouseLeave events propagate from the element being
left to the one being entered instead of ordinary bubbling and do not have a
capture phase.

Properties:

boolean altKey
number button
number buttons
number clientX
number clientY
boolean ctrlKey
boolean getModifierState(key)
boolean metaKey
number pageX
number pageY
DOMEventTarget relatedTarget
number screenX
number screenY
boolean shiftKey
Selection Events
Event names:

onSelect
Touch Events
Event names:

onTouchCancel onTouchEnd onTouchMove onTouchStart
Properties:

boolean altKey
DOMTouchList changedTouches
boolean ctrlKey
boolean getModifierState(key)
boolean metaKey
boolean shiftKey
DOMTouchList targetTouches
DOMTouchList touches
UI Events
Event names:

onScroll
Properties:

number detail
DOMAbstractView view
Wheel Events
Event names:

onWheel
Properties:

number deltaMode
number deltaX
number deltaY
number deltaZ
Media Events
Event names:

onAbort onCanPlay onCanPlayThrough onDurationChange onEmptied onEncrypted
onEnded onError onLoadedData onLoadedMetadata onLoadStart onPause onPlay
onPlaying onProgress onRateChange onSeeked onSeeking onStalled onSuspend
onTimeUpdate onVolumeChange onWaiting

Image Events
Event names:

onLoad onError
