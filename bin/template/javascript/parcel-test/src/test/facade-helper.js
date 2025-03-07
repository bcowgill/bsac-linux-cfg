/*
  help with testing exports from a Facade or module

  cp templates/facade.spec.js src/new/path/index.spec.js
  npm run test:unit --testRegex src/new/path/index.spec.js
*/

/* eslint-disable prefer-arrow-callback */
import keys from 'lodash/keys'
import isArray from 'lodash/isArray'
import forEach from 'lodash/forEach'

/*
// a simple test of a facade file for unit test coverage
import facadeTestHelper from './facade-helper';
import * as Facade from './';

const suite = 'src/TEMPLATE Facade';

// eslint-disable prefer-arrow-callback
describe(suite, function descTEMPLATEFacadeSuite() {
	const exportHelper = {
		suite,
		exportsTested: 0,
		totalExports: 2,
		// defaultExportType: 'object',
		defaultExports: ['ExampleContainer'],
		defaultExportNamed: 'ExampleContainer',
		// moreDefaultTests(defaultExport, Facade, exportHelper) { it(...); },
		// namedExports: ['TEMPLATE'],
		exportChecks: {
			ExampleContainer: {
				type: 'function',
				moreTests: function testTEMPLATE(exampleContainer) {
					expect(exampleContainer.displayName).toBe('Connect(ExampleContainer)');
				},
			},
		},
	};

	facadeTestHelper(exportHelper, Facade);
});

*/
export function checkConstant(obj, name, value = name) {
	it(`should have named constant ${name}`, function testNamedConstant() {
		expect(obj[name]).toBe(value)
	})
}

function facadeHelper(exportHelper, Facade) {
	function getType(thing) {
		if (isArray(thing)) {
			return 'array'
		}
		return typeof thing
	}

	function makeTestForExport(name, type, moreTests) {
		it(`should export ${name}`, function testExportsSomething() {
			/* eslint-disable no-param-reassign */
			exportHelper.exportsTested += 1
			/* eslint-enable no-param-reassign */
			expect(Facade[name]).toBeDefined()
			if (type === 'enum') {
				checkConstant(Facade, name)
			} else {
				expect(getType(Facade[name])).toBe(type)
			}
			if (moreTests) {
				moreTests(Facade[name])
			}
		})
	}

	it('should have correct number of exports', function testNumberOfExports() {
		const actual = keys(Facade).length
		/* istanbul ignore next */
		if (actual !== exportHelper.totalExports) {
			/* istanbul ignore next */
			/* eslint-disable no-console */
			console.error(
				`${exportHelper.suite}\nnamedExports`,
				keys(Facade).sort()
			)
			/* istanbul ignore next */
			console.error(Facade)
			/* eslint-enable no-console */
		}
		expect(actual).toBe(exportHelper.totalExports)
	})

	if (exportHelper.defaultExports || exportHelper.defaultExportType) {
		it('should export default', function testExportDefault() {
			const type = exportHelper.defaultExportType || 'object'
			/* eslint-disable no-param-reassign */
			exportHelper.exportsTested += 1
			/* eslint-enable no-param-reassign */
			expect(Facade.default).toBeDefined()
			expect(getType(Facade.default)).toBe(type)
		})
		if (exportHelper.defaultExports) {
			it('should export keys on default', function testExportDefaultKeys() {
				expect(keys(Facade.default).sort()).toEqual(
					exportHelper.defaultExports.sort()
				)
			})
		}
		if (exportHelper.defaultExportNamed) {
			it(`should export ${
				exportHelper.defaultExportNamed
			} as default`, function testExportNamedAsDefault() {
				expect(Facade.default[exportHelper.defaultExportNamed]).toBe(
					Facade[exportHelper.defaultExportNamed]
				)
			})
		}
		if (exportHelper.moreDefaultTests) {
			describe('more default export tests', function testMoreExportDefault() {
				exportHelper.moreDefaultTests(Facade.default, Facade, exportHelper)
			})
		}
	} else {
		it('should have no default export', function testNoExportDefault() {
			expect(Facade.default).toBeUndefined()
		})
	}

	if (exportHelper.namedExports) {
		it('should have named exports', function testExportsNamed() {
			expect(keys(Facade).sort()).toEqual(exportHelper.namedExports.sort())
		})
	}

	if (exportHelper.exportChecks) {
		forEach(keys(exportHelper.exportChecks), function testAnExport(
			exportName
		) {
			/* eslint-disable prefer-destructuring */
			const type = exportHelper.exportChecks[exportName].type
			const moreTests = exportHelper.exportChecks[exportName].moreTests
			/* eslint-enable prefer-destructuring */
			makeTestForExport(exportName, type, moreTests)
		})
	} else if (!exportHelper.namedExports) {
		it('should not have any named exports', function testNoNamedExports() {
			expect(keys(Facade)).toEqual(['default'])
		})
	}

	it('should have tested each exported value for type', function testNumberOfExportsTested() {
		expect(exportHelper.exportsTested).toBe(exportHelper.totalExports)
	})
}

export default facadeHelper
