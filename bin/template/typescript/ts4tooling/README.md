# Typescript <5 tooling (w/o fast compilation with swc)

TODO:
MUSTDO use a bundler to build browser / node versions
MUSTDO try using sonar for additional code analysis?
MUSTDO template scripting, my perl version or a node module?
MUSTDO platform and feature.js module for support detection in logObject 

// TODO(BSAC) node-notifier -- does not seem to work well on Mac -- maybe need a jest command option?

[Article from Javascript Weekly](https://featurist.co.uk/blog/running-typescript-in-node-with-near-zero-compilation-cost/)
[OMITTED - Speedy Web Compiler](https://swc.rs)
[Typescript](https://www.typescriptlang.org)
[ES Lint](https://typescript-eslint.io/getting-started)
[Prettier](https://blog.logrocket.com/linting-typescript-eslint-prettier/)
[Jest](https://jestjs.io/docs/getting-started)
[ts-jest](https://kulshekhar.github.io/ts-jest/docs/getting-started/installation)
[Benchmark](https://openbase.com/js/benchmark)
[Microtime timer](https://github.com/wadey/node-microtime)
[platform](https://github.com/bestiejs/platform.js#readme)
[feature.js](https://featurejs.com)
[feature.js github](https://github.com/arielsalminen/feature.js)
[Modernizr](https://modernizr.com/)
[Modernizr to detect browser features](http://html5doctor.com/using-modernizr-to-detect-html5-features-and-provide-fallbacks/#:~:text=Modernizr%20is%20a%20JavaScript%20library,that%20do%20not%20support%20them.)

## Install everything needed:

npm install --save-dev typescript prettier eslint eslint-plugin-import eslint-config-prettier ts-jest @tsconfig/node16 @typescript-eslint/parser @typescript-eslint/eslint-plugin @jest/globals jest-junit nyc-dark node-notifier  microtime benchmark @types/benchmark json5 platform @types/platform feature.js jest-environment-jsdom canvas

## Now add benchmarking to test different code implementations:

npm install --save-dev microtime

git clone https://github.com/wadey/node-microtime.git
|| git clone git@github.com:wadey/node-microtime.git
npm install
npm test microtime # to estimate the clock resolution of the machine you are running on

Running on Mac 
>system_profiler SPSoftwareDataType SPHardwareDataType
      System Version: macOS 11.6.5 (20G527)
      Kernel Version: Darwin 20.6.0
      Model Name: MacBook Pro
      Model Identifier: MacBookPro11,3
      Processor Name: Quad-Core Intel Core i7
      Processor Speed: 2.5 GHz
      Number of Processors: 1
      Total Number of Cores: 4
      L2 Cache (per Core): 256 KB
      L3 Cache: 6 MB
      Hyper-Threading Technology: Enabled
      Memory: 16 GB
>system_profiler -listDataTypes
> system_profiler SPStorageDataType
    Aristotle:

      Free: 317.49 GB (317,485,891,584 bytes)
      Capacity: 500.07 GB (500,068,036,608 bytes)


> microtime@3.1.1 test
> node test.js microtime

microtime.now() = 1676964324887857
microtime.nowDouble() = 1676964324.89402
microtime.nowStruct() = [ 1676964324, 894179 ]

Guessing clock resolution...
Clock resolution observed: 1us


npm i --save-dev microtime benchmark

var Benchmark = require('benchmark');

var suite = new Benchmark.Suite;

// add tests
suite.add('RegExp#test', function() {
  /o/.test('Hello World!');
})
.add('String#indexOf', function() {
  'Hello World!'.indexOf('o') > -1;
})
// add listeners
.on('cycle', function(event) {
  console.log(String(event.target));
})
.on('complete', function() {
  console.log('Fastest is ' + this.filter('fastest').map('name'));
})
// run async
.run({ 'async': true });

// logs:
// => RegExp#test x 4,161,532 +-0.99% (59 cycles)
// => String#indexOf x 6,139,623 +-1.00% (131 cycles)
// => Fastest is String#indexOf

## Install platform to detect the environment

npm install --save-dev platform @types/platform

Qutebrowser:
{
    "name": "Chrome",
    "version": "83.0.4103.122",
    "layout": "Blink",
    "prerelease": null,
    "os": "OS X 10.16.0 64-bit",
    "manufacturer": null,
    "product": null,
    "description": "Chrome 83.0.4103.122 on OS X 10.16.0 64-bit",
    "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_16_0) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.15.2 Chrome/83.0.4103.122 Safari/537.36"
}

Safari:
{
    "name": "Safari",
    "version": "15.4",
    "layout": "WebKit",
    "prerelease": null,
    "os": "OS X 10.15.7",
    "manufacturer": null,
    "product": null,
    "description": "Safari 15.4 on OS X 10.15.7",
    "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"
}

Node:
{
  description: 'Node.js 18.12.1 on Darwin 64-bit',
  layout: null,
  manufacturer: null,
  name: 'Node.js',
  prerelease: null,
  product: null,
  ua: null,
  version: '18.12.1',
  os: {
    architecture: 64,
    family: 'Darwin',
    version: null,
    toString: [Function: toString]
  },
  parse: [Function: parse],
  toString: [Function: toStringPlatform]
}

## Install feature.js to detect supported browser features

npm install --save-dev feature.js jest-environment-jsdom canvas
jest config change from testEnvironment node to jsdom
with jsdom, global object in node becomes a Window object
global.feature or global.window.feature provides access to the feature object.

## Trying modernizr detection

npm install --save-dev modernizr @types/modernizr

Selected ALL tests from modernizr build page and downloaded a 
modernizr.config.json file then built the library with npm run modernizr

[Modernizr Download Full Library](https://modernizr.com/download?MessageChannel-adownload-ambientlight-animation-apng-appearance-applicationcache-arrow-atobbtoa-audio-audioloop-audiopreload-backdropfilter-backgroundblendmode-backgroundcliptext-backgroundsize-batteryapi-bdi-beacon-bgpositionshorthand-bgpositionxy-bgrepeatspace_bgrepeatround-bgsizecover-blobconstructor-bloburls-blobworkers-borderimage-borderradius-boxshadow-boxsizing-canvas-canvasblending-canvastext-canvaswinding-capture-checked-classlist-contains-contenteditable-contextmenu-cookies-cors-createelementattrs_createelement_attrs-cryptography-cssall-cssanimations-csscalc-csschunit-csscolumns-cssescape-cssexunit-cssfilters-cssgradients-cssgrid_cssgridlegacy-csshyphens_softhyphens_softhyphensfind-cssinvalid-cssmask-csspointerevents-csspositionsticky-csspseudoanimations-csspseudotransitions-cssreflections-cssremunit-cssresize-cssscrollbar-csstransforms-csstransforms3d-csstransformslevel2-csstransitions-cssvalid-cssvhunit-cssvmaxunit-cssvminunit-cssvwunit-cubicbezierrange-customelements-customevent-customprotocolhandler-dart-datachannel-datalistelem-dataset-datauri-dataview-dataworkers-details-devicemotion_deviceorientation-directory-display_runin-displaytable-documentfragment-ellipsis-emoji-es5-es5array-es5date-es5function-es5object-es5string-es5syntax-es5undefined-es6array-es6collections-es6math-es6number-es6object-es6string-eventlistener-eventsource-exiforientation-fetch-fileinput-filereader-filesystem-flash-flexbox-flexboxlegacy-flexboxtweener-flexwrap-focuswithin-fontface-forcetouch-formattribute-formvalidation-framed-fullscreen-gamepads-generatedcontent-generators-geolocation-getrandomvalues-getusermedia-hairline-hashchange-hidden-hiddenscroll-history-hovermq-hsla-htmlimports-ie8compat-imgcrossorigin-indexeddb-indexeddbblob-inlinesvg-input-inputformaction-inputformenctype-inputformmethod-inputformtarget-inputtypes-intl-jpeg2000-jpegxr-json-lastchild-ligatures-localizednumber-localstorage-lowbandwidth-lowbattery-matchmedia-mathml-mediaqueries-microdata-multiplebgs-mutationobserver-notification-nthchild-objectfit-olreversed-oninput-opacity-outputelem-overflowscrolling-pagevisibility-passiveeventlisteners-peerconnection-performance-picture-placeholder-pointerevents-pointerlock-pointermq-postmessage-preserve3d-progressbar_meter-promises-proximity-queryselector-quotamanagement-regions-requestanimationframe-requestautocomplete-rgba-ruby-sandbox-scriptasync-scriptdefer-scrollsnappoints-seamless-search-serviceworker-sessionstorage-shapes-sharedworkers-siblinggeneral-sizes-smil-speechrecognition-speechsynthesis-srcdoc-srcset-strictmode-stylescoped-subpixelfont-supports-svg-svgasimg-svgclippaths-svgfilters-svgforeignobject-target-template-templatestrings-textalignlast-textareamaxlength-textshadow-texttrackapi_track-time-todataurljpeg_todataurlpng_todataurlwebp-touchevents-transferables-typedarrays-unicode-unicoderange-unknownelements-urlparser-urlsearchparams-userdata-userselect-variablefonts-vibrate-video-videoautoplay-videocrossorigin-videoloop-videopreload-vml-webaudio-webgl-webglextensions-webintents-webp-webpalpha-webpanimation-webplossless_webp_lossless-websockets-websocketsbinary-websqldatabase-webworkers-willchange-wrapflow-xdomainrequest-xhr2-xhrresponsetype-xhrresponsetypearraybuffer-xhrresponsetypeblob-xhrresponsetypedocument-xhrresponsetypejson-xhrresponsetypetext-setclasses)