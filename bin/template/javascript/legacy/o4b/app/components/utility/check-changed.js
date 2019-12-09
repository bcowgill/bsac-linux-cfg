// check-changed.js - A shouldComponentUpdate helper to check
// for changes in property values and log the changes if debugging.

/*
  Example usage:

  class Component extends React.Component {
    ...
    // props for shouldComponentUpdate checks
    static updateProps = [
      'accounts',
      'enableSearch'
    ];
    static updateState = ['filteredAccounts'];
    ...
    shouldComponentUpdate(nextProps, nextState) {
      return (
        checkChanges(
          nextProps,
          this.props,
          Component.updateProps,
          `${displayName} props`
        ) ||
        checkChanges(
          nextState,
          this.state,
          Component.updateState,
          `${displayName} state`
        )
      );
    }
  }

 */

const displayName = 'checkChanges';

const DEBUG = false;
const DUMP_LIMIT = 10;

const warn = console.warn;

export function isObj(obj) {
  return !(
    obj === null ||
    typeof obj !== 'object' ||
    Array.isArray(obj) ||
    obj instanceof RegExp
  );
}

export function toConsole(obj) {
  return obj instanceof RegExp ? `${obj}` : obj;
}

export function dumpArrayChanges(
  propName,
  nextProp,
  prop,
  componentName = displayName
) {
  let dumped = false;
  const context = `${componentName} ${propName}`;
  const nextLength = nextProp.length;
  const length = prop.length;
  if (nextLength !== length) {
    dumped = true;
    warn(`${context} array length changed`);
  } else {
    for (let index = 0; index < length; index += 1) {
      if (nextProp[index] !== prop[index]) {
        dumped += 1;
        if (dumped <= DUMP_LIMIT) {
          warn(
            `${context}[${index}] changed`,
            toConsole(nextProp[index]),
            toConsole(prop[index])
          );
        }
      } // props differ
    } // for
    if (!dumped) {
      dumped = true;
      warn(`${context} !== but arrays identical`);
    }
  } // else
  return dumped;
}

export function dumpObjectChanges(
  propName,
  nextProp,
  prop,
  componentName = displayName
) {
  let dumped = false;
  const context = `${componentName} ${propName}`;
  const nextKeys = Object.keys(nextProp).sort();
  const keys = Object.keys(prop).sort();
  if (
    nextKeys.length !== keys.length ||
    nextKeys.join('$') !== keys.join('$')
  ) {
    dumped = true;
    warn(`${context} object keys differ`, nextKeys, keys);
  } else {
    for (let idx = 0; idx < nextKeys.length; idx += 1) {
      const name = nextKeys[idx];
      if (nextProp[name] !== prop[name]) {
        dumped += 1;
        if (dumped <= DUMP_LIMIT) {
          warn(`${context}[${name}] changed`, nextProp[name], prop[name]);
        }
      } // props differ
    } // for
    if (!dumped) {
      dumped = true;
      warn(`${context} !== but objects identical`);
    }
  } // else
  return dumped;
}

export function dumpChanges(
  propName,
  nextProp,
  prop,
  componentName = displayName
) {
  let dumped = false;
  const context = `${componentName}.checkChanges`;
  if (Array.isArray(nextProp) && Array.isArray(prop)) {
    dumped = dumpArrayChanges(propName, nextProp, prop, context);
  } else if (isObj(nextProp) && isObj(prop)) {
    dumped = dumpObjectChanges(propName, nextProp, prop, context);
  }
  if (!dumped) {
    warn(`${context} ${propName} !==`, toConsole(nextProp), toConsole(prop));
  }
}

export function checkChanges(
  nextProps,
  props,
  propsList,
  componentName = displayName
) {
  let changed = false;
  for (let idx = 0; idx < propsList.length; idx += 1) {
    const name = propsList[idx];
    if (nextProps[name] !== props[name]) {
      changed = true;
      // istanbul ignore next
      if (DEBUG) {
        dumpChanges(name, nextProps[name], props[name], componentName);
      }
    } // prop differs
    break;
  }
  return changed;
}
