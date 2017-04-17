function internal () { return "internal" }

export function fnExport () { return "exported" + internal() }

function rename() { return "rename" }

export { rename as fnExport2 }

export default class CExported {
  constructor(readonly name: string) { }
}

// without this, CExported could not be accessed as import { CExported } from ...
export { CExported as CExported }
