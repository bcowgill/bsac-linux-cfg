// configured in jest.config.js to run once before each test suite is executed
// can perform global test setup for uniformity.
// console.log('in jest-setup.js');
import Radium from 'radium';

Radium.TestMode.enable();
