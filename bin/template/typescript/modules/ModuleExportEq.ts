function internal () { return "internal" }

// cannot export individual symbols when we use export = in a module
/* export */ function fnExport () { return "exported" + internal() }

function rename() { return "rename" }

// export { rename as fnExport2 }

class CExported {
  constructor(readonly name: string) { }
}

// Must include all exports in the single exported object
// this is not allowed for es2015 or system modules, use export default instead
export = {
  fnExport, fnExport2 : rename, CExported
}
