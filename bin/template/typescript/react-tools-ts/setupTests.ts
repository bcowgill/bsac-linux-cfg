// setupTests.ts
import 'regenerator-runtime/runtime';
import '@testing-library/jest-dom/extend-expect';
import { configure } from '@testing-library-react';
import { mockWindowNotImplementedMethods } from './testingTools';
import { MockBroadcastChannel } from 'mockBroadcastMessage';

// Sets the timeout for async waitFor methods.
configure({ asyncUtilTimeout: 10000 });

mockWindowNotImplementedMethods();

// Install our mock constructor for new channels.
global.BroadcastChannel = MockBroadcastChannel;
