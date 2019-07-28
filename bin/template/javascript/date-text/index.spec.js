// a simple test of a facade file for unit test coverage
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import facadeTestHelper from '../parcel-test/src/test/facade-helper';
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import * as Facade from './';

const suite = 'src/DateText Facade';

/* eslint-disable prefer-arrow-callback */
describe(suite, function descDateTextFacadeSuite() {
  const exportHelper = {
    suite,
    exportsTested: 0,
    totalExports: 4,
    defaultExportType: 'function',
    defaultExports: ['defaultProps', 'displayName', 'propTypes'],
    moreDefaultTests(defaultExport) {
      it('should have correct displayName', function testDateTextDisplayName() {
        expect(defaultExport.displayName).toBe('DateText');
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
