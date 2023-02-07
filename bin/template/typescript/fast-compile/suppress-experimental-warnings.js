// const util = require('util')
const defaultEmit = process.emit

const message = /Custom ESM Loaders is an experimental feature./

process.emit = function (...args) {
  const error = args[1]
  if (error.name === 'ExperimentalWarning' && message.test(error.message))
  {
    // console.warn(`args[1]:${error.constructor.name} args:`, util.inspect(args))
    return undefined
  }

  return defaultEmit.call(this, ...args)
}
