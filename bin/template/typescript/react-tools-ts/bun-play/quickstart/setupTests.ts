// initial setup for test plans
import { setSystemTime, beforeEach } from 'bun:test';

// Always run the tests with a specific date/time to avoid leap year
// or DST issues unless you are specifically testing that.
const FREEZE_TIME = '2020-01-02T12:13:14.789Z';

beforeEach(() => {
  setSystemTime(new Date(FREEZE_TIME));
});
