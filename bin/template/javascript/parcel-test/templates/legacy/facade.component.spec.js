// a simple test of a facade file for unit test coverage
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import facadeTestHelper from 'specs/test-tools/facade-helper';
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import * as Facade from './';

const suite = 'src/components/TEMPLATE Facade';

/* eslint-disable prefer-arrow-callback */
describe(suite, function descTEMPLATEFacadeSuite() {
  const exportHelper = {
    suite,
    exportsTested: 0,
    totalExports: 4,
    defaultExportType: 'function',
    defaultExports: ['defaultProps', 'displayName', 'propTypes'],
    moreDefaultTests(defaultExport) {
      it('should have correct displayName', function testTEMPLATEDisplayName() {
        expect(defaultExport.displayName).toBe('TEMPLATE');
      });
    },
    exportChecks: {
      defaultProps: { type: 'object' },
      displayName: { type: 'string' },
      propTypes: { type: 'object' },
    },
  };

  facadeTestHelper(exportHelper, Facade);
});
