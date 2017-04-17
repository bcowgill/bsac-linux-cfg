function internal () { return "internal" }

// cannot export individual symbols when we use export = in a module
/* export */ function fnExport () { return "exported" + internal() }

function rename() { return "rename" }

// export { rename as fnExport2 }

class CExported {
  constructor(readonly name: string) { }
}

// Must include all exports in the single exported object
export = {
  fnExport, fnExport2 : rename, CExported
}
