import replace from 'lodash/replace';
import format from 'date-fns/format';

function getTimeZoneName(date) {
  let zoneName = '';
  const match = date.toString().match(/(\(.+\))/);
  /* istanbul ignore next */
  if (match) {
    zoneName = match[1];
  }
  return zoneName;
}

export default function dateFormat(template, date = new Date()) {
  let templateDateFns = template;
  if (template) {
    templateDateFns = replace(template, /\bZZZ\b/g, '|||222|||');
  }
  return replace(
    format(date, templateDateFns),
    /\|\|\|222\|\|\|/g,
    getTimeZoneName(date),
  );
}
