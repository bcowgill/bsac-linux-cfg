const timeZoneInfo = {
  TEST_TIME: 'December 25, 1991 12:12:59 GMT',
  TEST_SUMMER_TIME: 'July 22, 1991 12:13:59',
  UTC: {
    // Jenkins no Daylight time
    0: {
      ISO_DATE: '1991-12-25T12:12:59.000Z',
      ISO_SUMMER_DATE: '1991-07-22T12:13:59.000Z',
      LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
      LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Standard Time)',
    },
  },
  'Europe/London': {
    0: {
      ISO_DATE: '1991-12-25T12:12:59.000Z',
      LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
    },
    '-60': {
      ISO_SUMMER_DATE: '1991-07-22T11:13:59.000Z',
      LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Daylight Time)',
    },
  },
  'America/Vancouver': {
    480: {
      ISO_DATE: '1991-12-25T12:12:59.000Z',
      LOCAL_DATE: 'Wednesday 25 Dec 1991 4:12:59 AM (Pacific Standard Time)',
    },
    420: {
      ISO_SUMMER_DATE: '1991-07-22T19:13:59.000Z',
      LOCAL_SUMMER_DATE:
        'Monday 22 Jul 1991 12:13:59 PM (Pacific Daylight Time)',
    },
  },
};

export default timeZoneInfo;
