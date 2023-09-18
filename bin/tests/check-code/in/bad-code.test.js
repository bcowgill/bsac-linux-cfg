// testcase zymosis
expect(element.getAttribute('width')).toBe(false)
// expect(element.getAttribute('width')).toBe(false) OKEY
expect(element.getAttribute('width')).toMatch() // OKEY
(element.getAttribute("value") === "true")

// testcase zymase
await waitFor(() => expect(asFragment()).toMatchSnapshot())

// testcase zoroaster
expect(got).toBe;
expect(got).toBeTruthy
expect(got).toEqual  ;
expect(got).toHaveBeenCalledWith // also a problem
__vendor__/x.test.js: expect(got).toBeNull; // OKEY
__scripts__/x.test.js: expect(got).toBeNull; // OKEY

// testcase zoril
fdescribe("test suite");
describe.only("test suite");
fit("test case");
it.only("test case");
__vendor__/x.test.js: fit("test case"); // OKEY
__scripts__/x.test.js: fit("test case"); // OKEY
