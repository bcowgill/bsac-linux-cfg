//==========================================================
// mockBroadcastChannel.ts
// A basic mock of BroadcastChannel as node is missing it.
// Doesn't do everything but should stop your code from breaking when unit tested.

const DEBUG = false;
const displayName = 'MockBroadcastChannel';

// istanbul ignore next
if (global.BroadcastChannel) {
	throw new Error(
		'You are running in an environment which has BroadcastChannel support do you need this mock?',
	);
}

// istanbul ignore next
const debug = DEBUG ? console.warn : () => null;

export interface MockBroadcastChannel extends BroadcastChannel {
	[key: string]: unknown;
	name: string;
}
export type MockBroadcastChannelConstructor = new () => MockBroadcastChannel;

export function nameOf(mock: undefined | null | jest.Mock | unknown): string {
	// istanbul ignore next
	return mock && mock.getMockName ? `mock:${mock.getMockName()}` : 'non-mock';
}

// we use a single channel instance for testing...
const channel: MockBroadcastChannel = {
	name: 'UNNAMED',
	postMessage: jest.fn(),
	close: jest.fn(),
	addEventListener: jest.fn(),
	removeEventListener: jest.fn(),
	dispatchEvent: jest.fn(),
	onmessage: jest.fn(),
	onmessageerror: jest.fn(),
};
debug(`MOCKNAME`, nameOf(channel.postMessage));

let number = 0;
function setNameOf(mock: null | jest.Mock | unknown, name: string): void {
	// istanbul ignore else
	if (mock && mock.mockName) {
		mock.mockName(`${name}${number}`);
	}
}

function remockChannel(): void {
	number++;
	(channel.postMessage as jest.Mock).mockImplementation(function (
		message: any,
	) {
		debug(nameOf(nameOf(channel.postMessage)), message);
		try {
			JSON.parse(JSON.stringify(message));
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (_unusedException) {
			// istanbul ignore next
			if (typeof channel.onmessageerror === 'function') {
				channel.onmessageerror(message);
			}
		}
		// istanbul ignore else
		if (typeof channel.onmessage === 'function') {
			channel.onmessage(message);
		}
	});
	setNameOf(channel.postMessage, 'MockBroadcastChannel.postMessage');
	setNameOf(channel.close, 'MockBroadcastChannel.close');
	setNameOf(
		channel.addEventListener,
		'MockBroadcastChannel.addEventListener',
	);
	setNameOf(
		channel.removeEventListener,
		'MockBroadcastChannel.removeEventListener',
	);
	setNameOf(channel.dispatchEvent, 'MockBroadcastChannel.dispatchEvent');

	// istanbul ignore next
	if (!channel.onmessage) {
		channel.onmessage = jest.fn();
	}
	// istanbul ignore next
	if (!channel.onmessageerror) {
		channel.onmessageerror = jest.fn();
	}
	setNameOf(channel.onmessage, 'MockBroadcastChannel.onmessage');
	setNameOf(channel.onmessageerror, 'MockBroadcastChannel.onmessageerror');
} // remockChannel()
remockChannel();

/**
 * answers with the singleton mocked BroadcastChannel for unit testing
 * @returns {MockBroadcastChannel} singleton instance of channel for testing
 */
export function getMockChannel(remock = false): MockBroadcastChannel {
	// istanbul ignore else
	if (remock) {
		remockChannel();
	}
	debug(
		`${displayName}.getMockChannel name:${channel.name} mockName:${
			nameOf(
				channel.postMessage,
			)
		}`,
		channel.postMessage,
	);
	return channel;
} // getMockChannel()

/**
 * constructor for singleton mock BroadcastChannel
 * @param {string} name the name of the channel.
 * @note You should install this on the global object as follows:
 *   global.BroadcastChannel = MockBroadcastChannel;
 */
export const MockBroadcastChannel = function (
	this: MockBroadcastChannel,
	name: string,
) {
	debug(
		`${displayName} constructor(${name}) name:${channel.name} mockName:${
			nameOf(channel.postMessage)
		}`,
	);
	channel.name = channel.name === 'UNNAMED'
		? name
		: `${channel.name},${name}`;
	Object.keys(channel).forEach((key: string) => {
		this[key] = channel[key];
	});

	this.name = name;
	return this;
} as any as MockBroadcastChannelConstructor;
