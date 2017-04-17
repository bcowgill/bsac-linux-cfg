"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// import the default export only
var Module_1 = require("./Module");
new Module_1.default('the name');
// import the exports as named
// (omits the default export unless explicitly exported)
var ModuleExports = require("./Module");
ModuleExports.fnExport();
ModuleExports.fnExport2();
new ModuleExports.CExported('myname');
// import the exports giving them new names
var Module_2 = require("./Module");
Module_2.fnExport();
Module_2.fnExport2();
new Module_2.CExported('name2');
