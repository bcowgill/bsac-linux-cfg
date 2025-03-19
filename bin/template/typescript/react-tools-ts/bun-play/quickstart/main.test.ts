
describe("date frozen", () => {
  beforeEach(() => {
    jest.setSystemTime(new Date("2020-01-01T00:00:00.000Z"));
  });
  test("it is 2020", () => {
    expect(new Date().getFullYear()).toBe(2020);
  });
});

describe("arithmetic", () => {
  test("2 + 2", () => {
    expect(2 + 2).toBe(4);
  });

  test("2 * 2", () => {
    expect(2 * 2).toBe(4);
  });
});

describe("mock", () => {
  const random = jest.fn(() => Math.random());

  test("random", () => {
    const val = random();
    expect(val).toBeGreaterThan(0);
    expect(random).toHaveBeenCalled();
    expect(random).toHaveBeenCalledTimes(1);
  });
});

describe("time zones", () => {
  beforeEach(() => {
    jest.setSystemTime(new Date("2025-03-19:18:00.000Z"));
  });
  afterEach(() => {
    jest.setSystemTime();
  });

  function localTime(date: Date): string {
    return new Intl.DateTimeFormat("en-GB", { dateStyle: 'short', timeStyle: 'long' }).format(date);
  }

  interface ExpectDateTimeTest {
    label: string;
    useTime: string;
    offset?: number;
    shortDate: string;
  }
  function expectDateTime({
    label = '',
    useTime,
    offset = 0,
    shortDate,
  }: ExpectDateTimeTest): void {
    jest.setSystemTime(new Date(useTime));
    let date = new Date();
    expect(label + ' ' + date.getTimezoneOffset()).toBe(label + ' ' + offset);
    expect(label + ' ' + date.toISOString()).toBe(label + ' ' + useTime);
    expect(label + ' ' + localTime(date)).toBe(label + ' ' + shortDate);
  }

  // NOTE: process.env.TZ changing is not Jest compatible
  test("Welcome to UTC! - testing no offset change by day of year", () => {
    const offset = 0;
    process.env.TZ = "UTC";
    expect(new Date().getTimezoneOffset()).toBe(offset);
    expect(new Intl.DateTimeFormat().resolvedOptions().timeZone).toBe(
      "UTC",
    );
    // Time zone offset remains the same for the whole year
    for (let month = 1; month <= 12; month++) {
      for (let day = 1; day <= 31; day++) {
        expect(new Date(2025, month - 1, day).getTimezoneOffset()).toBe(offset);
      }
    }
  });

  test("Welcome to London! - testing time offset for BST dates", () => {
    const year = 2025;
    const monthDST = 3; // varies by year and TZ
    const dayDST = 30;
    const hourDST = 1; // forward 1 hour at 1AM
    const monthST = 10;
    const dayST = 26;
    const hourST = 2; // backward 1 hour at 2AM

    const offset = 0;
    const offsetDST = -60;

    process.env.TZ = "Europe/London";
    expect(new Date().getTimezoneOffset()).toBe(offset);
    expect(new Intl.DateTimeFormat().resolvedOptions().timeZone).toBe(
      "Europe/London",
    );

    // In the UK the clocks go forward 1 hour at 1am on the last Sunday in March, and back 1 hour at 2am on the last Sunday in October. The period when the clocks are 1 hour ahead is called British Summer Time (BST).

    // Day before BST starts
    expectDateTime({
      label: 'BST-1d',
      useTime: '2025-03-29T00:00:00.000Z',
      shortDate: '29/03/2025, 00:00:00 GMT',
    });

    // Just before BST starts until just after...
    expectDateTime({
      label: 'pre BST',
      useTime: `${year}-0${monthDST}-${dayDST}T0${hourDST - 1}:59:00.000Z`,
      shortDate: '30/03/2025, 00:59:00 GMT',
    });
    expectDateTime({
      label: '@BST',
      offset: offsetDST,
      useTime: `${year}-0${monthDST}-${dayDST}T0${hourDST}:00:00.000Z`,
      shortDate: '30/03/2025, 02:00:00 BST',
    });
    expectDateTime({
      label: 'post BST',
      offset: offsetDST,
      useTime: `${year}-0${monthDST}-${dayDST}T0${hourDST}:01:00.000Z`,
      shortDate: '30/03/2025, 02:01:00 BST',
    });

    // Day after BST starts
    expectDateTime({
      label: 'BST+1d',
      useTime: '2025-04-01T00:00:00.000Z',
      offset: offsetDST,
      shortDate: '01/04/2025, 01:00:00 BST',
    });

    // Day before BST ends
    expectDateTime({
      label: 'BST end-1d',
      useTime: '2025-10-25T00:00:00.000Z',
      offset: offsetDST,
      shortDate: '25/10/2025, 01:00:00 BST',
    });

    // Just before BST ends until just after...
    expectDateTime({
      label: 'pre BST end',
      useTime: `${year}-${monthST}-${dayST}T0${hourST - 2}:59:00.000Z`,
      offset: offsetDST,
      shortDate: '26/10/2025, 01:59:00 BST',
    });
    expectDateTime({
      label: '@BST end',
      useTime: `${year}-${monthST}-${dayST}T0${hourST - 1}:00:00.000Z`,
      shortDate: '26/10/2025, 01:00:00 GMT',
    });
    expectDateTime({
      label: 'post BST end',
      useTime: `${year}-${monthST}-${dayST}T0${hourST - 1}:01:00.000Z`,
      shortDate: '26/10/2025, 01:01:00 GMT',
    });

    // Day after BST ends
    expectDateTime({
      label: 'BST end+1d',
      useTime: '2025-10-27T00:00:00.000Z',
      shortDate: '27/10/2025, 00:00:00 GMT',
    });
  });

  test("Welcome to California! - testing time offset changes through the year", () => {
    const year = 2025;
    const monthDST = 3; // varies by year and TZ
    const dayDST = 10;
    const monthST = 11;
    const dayST = 3;

    const offset = 420;
    const offsetDST = 480;

    process.env.TZ = "America/Los_Angeles";
    expect(new Date().getTimezoneOffset()).toBe(offset);
    expect(new Intl.DateTimeFormat().resolvedOptions().timeZone).toBe(
      "America/Los_Angeles",
    );
    expect(new Date().toLocaleString()).toBe('3/19/2025, 11:00:00 AM');

    // Time zone offset changes through the whole year
    for (let month = 1; month <= 12; month++) {
      for (let day = 1; day <= 31; day++) {
	const ofs = new Date(year, month - 1, day).getTimezoneOffset();
	if (month === monthDST && day >= dayDST || (month > monthDST && month < monthST) || month === monthST && day < dayST) {
          // Daylight Savings time begins Mar 10
          expect(`${year}-${month}-${day} ${ofs}`).toBe(`${year}-${month}-${day} ${offset}`);
	}
	else {
          // Normal time until Mar 10 and from Nov 3
          expect(`${year}-${month}-${day} ${ofs}`).toBe(`${year}-${month}-${day} ${offsetDST}`);
	}
      }
    }
  });

  test("Welcome to New York!", () => {
    // Unlike in Jest, you can set the timezone multiple times at runtime and it will work.
    process.env.TZ = "America/New_York";
    expect(new Date().getTimezoneOffset()).toBe(240);
    expect(new Intl.DateTimeFormat().resolvedOptions().timeZone).toBe(
      "America/New_York",
    );
    expect(new Date().toLocaleString()).toBe('3/19/2025, 2:00:00 PM');
  });
});

describe("DOM test", () => {
  test('dom test', () => {
    document.body.innerHTML = `<button>My button</button>`;
    const button = document.querySelector('button');
    expect(button?.innerText).toEqual('My button');
  });
});
