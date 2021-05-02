/* eslint-disable prefer-arrow-callback */
import { setTitle } from './set-title'

const suite = 'src/actions/ setTitle Actions'

describe(suite, function descSetTitleActionSuite() {
	it('should return a set title action', function testSetTitleAction() {
		const expected = {
			title: 'PAGE TITLE',
			type: 'SET_TITLE',
		}
		const actual = setTitle('PAGE TITLE')
		expect(actual).toEqual(expected)
	})
})
