// NodeWindow.js
// provide a window object so that third party modules
// can have access to mocked window properties in test plans

'use strict'

import Env from '../../src/es6/Env'
import FakeBrowser from './FakeBrowser'

let our
const displayName = 'NodeWindow'
    , get = function (member) {
        const instance = FakeBrowser.getInstance()
            , accessor = 'get' + member.substring(0, 1).toUpperCase()
                + member.substring(1)
            , win = instance.getWindow()
        if (accessor in instance) {
            return instance[accessor]()
        }
        if (!(member in win)) {
            // MUSTDO choose better Error object
            throw new Error(displayName + ' window.' + member + ' has not been mocked')
        }
        return win[member]
    }
    , NodeWindow = {
        get window () {
            return our
        }

        , get frames () {
            return our
        }

        , get parent () {
            return our
        }

        , get self () {
            return our
        }

        , get top () {
            return our
        }

        , get console () {
            return get('console')
        }

        , get history () {
            return get('history')
        }

        , get navigator () {
            return get('navigator')
        }

        , get document () {
            return get('document')
        }

        , get location () {
            return get('location')
        }

        , get localStorage () {
            return get('localStorage')
        }

        , get sessionStorage () {
            return get('sessionStorage')
        }

        , get _inherits () {
            return [displayName]
        }
    }

our = our || NodeWindow

if (!Env.isNode) {
    console.error(displayName + ' should not be included in a non-node environment')
}

export default NodeWindow

const WINDOW_API = {
    alert: 'function native alert'
    , applicationCache: 'ApplicationCache'
    , atob: 'function native atob'
    , blur: 'function native'
    , btoa: 'function native btoa'
    , caches: 'CacheStorage'
    , cancelAnimationFrame: 'function native cancelAnimationFrame'
    , cancelIdleCallback: 'function native cancelIdleCallback'
    , captureEvents: 'function native captureEvents'
    , chrome: 'Object'
    , clearInterval: 'function native clearInterval'
    , clearTimeout: 'function native clearTimeout'
    , clientInformation: 'Navigator'
    , close: 'function native'
    , closed: 'boolean'
    , confirm: 'function native confirm'
    , console: 'Object'
    , crypto: 'Crypto'
    , defaultStatus: 'string'
    , defaultstatus: 'string'
    , devicePixelRatio: 'number'
    , document: 'HTMLDocument'
    , external: 'Object'
    , fetch: 'function native fetch'
    , find: 'function native find'
    , focus: 'function native'
    , frameElement: 'null'
    , frames: 'global'
    , getComputedStyle: 'function native getComputedStyle'
    , getMatchedCSSRules: 'function native getMatchedCSSRules'
    , getSelection: 'function native getSelection'
    , history: 'History'
    , indexedDB: 'IDBFactory'
    , innerHeight: 'number'
    , innerWidth: 'number'
    , isSecureContext: 'boolean'
    , length: 'number'
    , localStorage: 'Storage'
    , location: 'Location'
    , locationbar: 'BarProp'
    , matchMedia: 'function native matchMedia'
    , menubar: 'BarProp'
    , moveBy: 'function native moveBy'
    , moveTo: 'function native moveTo'
    , name: 'string'
    , navigator: 'Navigator'
    , onabort: 'null'
    , onanimationend: 'null'
    , onanimationiteration: 'null'
    , onanimationstart: 'null'
    , onautocomplete: 'null'
    , onautocompleteerror: 'null'
    , onbeforeunload: 'null'
    , onblur: 'null'
    , oncancel: 'null'
    , oncanplay: 'null'
    , oncanplaythrough: 'null'
    , onchange: 'null'
    , onclick: 'null'
    , onclose: 'null'
    , oncontextmenu: 'null'
    , oncuechange: 'null'
    , ondblclick: 'null'
    , ondevicemotion: 'null'
    , ondeviceorientation: 'null'
    , ondrag: 'null'
    , ondragend: 'null'
    , ondragenter: 'null'
    , ondragleave: 'null'
    , ondragover: 'null'
    , ondragstart: 'null'
    , ondrop: 'null'
    , ondurationchange: 'null'
    , onemptied: 'null'
    , onended: 'null'
    , onerror: 'null'
    , onfocus: 'null'
    , onhashchange: 'null'
    , oninput: 'null'
    , oninvalid: 'null'
    , onkeydown: 'null'
    , onkeypress: 'null'
    , onkeyup: 'null'
    , onlanguagechange: 'null'
    , onload: 'null'
    , onloadeddata: 'null'
    , onloadedmetadata: 'null'
    , onloadstart: 'null'
    , onmessage: 'null'
    , onmousedown: 'null'
    , onmouseenter: 'null'
    , onmouseleave: 'null'
    , onmousemove: 'null'
    , onmouseout: 'null'
    , onmouseover: 'null'
    , onmouseup: 'null'
    , onmousewheel: 'null'
    , onoffline: 'null'
    , ononline: 'null'
    , onpagehide: 'null'
    , onpageshow: 'null'
    , onpause: 'null'
    , onplay: 'null'
    , onplaying: 'null'
    , onpopstate: 'null'
    , onprogress: 'null'
    , onratechange: 'null'
    , onreset: 'null'
    , onresize: 'null'
    , onscroll: 'null'
    , onsearch: 'null'
    , onseeked: 'null'
    , onseeking: 'null'
    , onselect: 'null'
    , onshow: 'null'
    , onstalled: 'null'
    , onstorage: 'null'
    , onsubmit: 'null'
    , onsuspend: 'null'
    , ontimeupdate: 'null'
    , ontoggle: 'null'
    , ontransitionend: 'null'
    , onunload: 'null'
    , onvolumechange: 'null'
    , onwaiting: 'null'
    , onwebkitanimationend: 'null'
    , onwebkitanimationiteration: 'null'
    , onwebkitanimationstart: 'null'
    , onwebkittransitionend: 'null'
    , onwheel: 'null'
    , open: 'function native open'
    , openDatabase: 'function native openDatabase'
    , opener: 'null'
    , outerHeight: 'number'
    , outerWidth: 'number'
    , pageXOffset: 'number'
    , pageYOffset: 'number'
    , parent: 'global'
    , performance: 'Performance'
    , personalbar: 'BarProp'
    , postMessage: 'function native'
    , print: 'function native print'
    , prompt: 'function native prompt'
    , releaseEvents: 'function native releaseEvents'
    , requestAnimationFrame: 'function native requestAnimationFrame'
    , requestIdleCallback: 'function native requestIdleCallback'
    , resizeBy: 'function native resizeBy'
    , resizeTo: 'function native resizeTo'
    , screen: 'Screen'
    , screenLeft: 'number'
    , screenTop: 'number'
    , screenX: 'number'
    , screenY: 'number'
    , scroll: 'function native scroll'
    , scrollBy: 'function native scrollBy'
    , scrollTo: 'function native scrollTo'
    , scrollX: 'number'
    , scrollY: 'number'
    , scrollbars: 'BarProp'
    , self: 'global'
    , sessionStorage: 'Storage'
    , setInterval: 'function native setInterval'
    , setTimeout: 'function native setTimeout'
    , speechSynthesis: 'SpeechSynthesis'
    , status: 'string'
    , statusbar: 'BarProp'
    , stop: 'function native stop'
    , styleMedia: 'StyleMedia'
    , toolbar: 'BarProp'
    , top: 'global'
    , webkitCancelAnimationFrame: 'function native webkitCancelAnimationFrame'
    , webkitCancelRequestAnimationFrame: 'function native webkitCancelRequestAnimationFrame'
    , webkitIndexedDB: 'IDBFactory'
    , webkitRequestAnimationFrame: 'function native webkitRequestAnimationFrame'
    , webkitRequestFileSystem: 'function native webkitRequestFileSystem'
    , webkitResolveLocalFileSystemURL: 'function native webkitResolveLocalFileSystemURL'
    , webkitStorageInfo: 'DeprecatedStorageInfo'
    , window: 'global'
}
