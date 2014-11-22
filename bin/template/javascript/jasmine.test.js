/**
	Test plan for javascript OBJECT (using jasmine/karma)
	Displays the test plan name and object file being tested
	when using the karma spec reporter.

	@file
	@author AUTHOR
	@requires public/PATH/FILENAME.js
	@requires jasmine

	@see {@link http://jasmine.github.io/2.0/introduction.html Jasmine API Documentation}

	@todo AUTHOR to implement the tests for this.
*/
/*jshint browser: true, indent: 4, smarttabs: true, maxstatements: 50 */
/*global TestMe, afterEach, describe, beforeEach, expect, it, xdescribe, xit */


// HELP Template substitution values:
// AUTHOR == who will implement this test plan
// test/PATH == path to test plan file
// public/PATH == path to javascript object being tested
// OBJECT == name of javascript object under test
// FILENAME == base filename of javascript object being tested
// /HELP

/*
	======== A Handy Little Jasmine Test Reference ========
	http://jasmine.github.io/2.0/introduction.html

	Test suites/specs (jasmine):
		describe(suite, [fn]);  // omitting function marks it as a pending suite/spec
		it(spec, [fn]);
		xdescribe/xit(suite, fn); // test marked pending and skips execution
		beforeEach(fn);
		afterEach(fn);

	Test expectation matchers:
		expect(actual).toBe(expected);  // ===
		expect(actual).not.toBe(expected);
		expect(actual).toEqual(expected);
		expect(actual).toMatch(regex);  // TODO does it work on arrays?
		expect(actual).toBeDefined();
		expect(actual).toBeUndefined();
		expect(actual).toBeNull();
		TODO finish documenting this
*/

describe('test/PATH/FILENAME.test.js', function() {
	'use strict';

	describe('using public/PATH/FILENAME.js', function() {

		// Simple test suite with not very deeply nested describes.
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

