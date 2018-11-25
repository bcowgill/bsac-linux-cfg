import { prettify } from './snapshot'

const suite = 'specs/test-tools/snapshot'

/* eslint-disable no-useless-escape */
// You should be able to paste the HTML output shown on the console directly
// and the prettify function will take care of the spacing differences.
const HTML = `
<div> <div class="classy" data-name="froggy"><blah/>
    CHILDREN OF THE APP. CHILDREN OF THE CORN. <blah attr="something"/></div></div>`
/* eslint-enable no-useless-escape */

const expected = `<div>
<div
  className="classy"
  data-name="froggy"
>
<blah />
CHILDREN OF THE APP.
CHILDREN OF THE CORN.
<blah
  attr="something"
/>
</div>
</div>`

const expectedQuoted = `<div>\n${expected}\n</div>`

/* eslint-disable prefer-arrow-callback */
describe(suite, function descSnapshotSuite() {
	it('should format snapshot HTML for comparison', function testSnapshot() {
		const actual = prettify(HTML)
		expect(actual).toBe(expected)
	})

	it('should handle surrounding quotes', function testSnapshotQuoted() {
		const actual = prettify(`\n"<div>${HTML}</div>"\n`)
		expect(actual).toBe(expectedQuoted)
	})
})
