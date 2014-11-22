// A test plan template which displays the test plan name and
// object file being tested.
// TODO - jsdoc and substitutions
describe('test/PATH/FILENAME.test.js', function() {
	'use strict';

	describe('using public/PATH/FILENAME.js', function() {

		// Simple test suite, not very deeply nested describes.
		describe('OBJECT.method()', function() {
			it('Should return something ', function() {
				expect(false)
					.toBeFalsy();
			});
		}); // end method() tests

		// More complex test suite with nested describes to split 
		// tests into categories. But the output reporter may fail
		// to show all the levels of describe comments so we output
		// the name of the test plan and object as passing tests.
		describe('OBJECT.method()', function() {
			describe('ERROR cases', function() {
				// Because of the depth of nested describe() functions
				// the test plan name/and object under test are not shown
				// using the karma spec reporter
				// so we create a passing test just to output them
				it('test/PATH/FILENAME.test.js', function() {
					expect(true).toBeTruthy();
				});
				it('using public/PATH/FILENAME.js', function() {
					expect(true).toBeTruthy();
				});

				it('Should return something ', function() {
					expect(false)
						.toBeFalsy();
				});
			}); // end ERROR cases tests
		}); // end method() tests
	}); // end js file being tested
}); // end test plan

