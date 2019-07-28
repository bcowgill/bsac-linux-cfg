// a simple test of a facade file for unit test coverage
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import facadeTestHelper from 'specs/test-tools/facade-helper';
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import * as Facade from './';

const suite = 'src/TEMPLATE Facade';

/* eslint-disable prefer-arrow-callback */
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
          expect(exampleContainer.displayName).toBe(
            'Connect(ExampleContainer)',
          );
        },
      },
    },
  };

  facadeTestHelper(exportHelper, Facade);
});
