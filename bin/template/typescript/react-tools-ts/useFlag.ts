// useFlag.ts - a hook for boolean data with set/clear/toggle/reset setters.
import { useCallback, useState } from 'react';

export interface IFlagSettors {
	set: () => void;
	clear: () => void;
	toggle: () => void;
	reset: () => void;
}

export interface IFlagHook extends IFlagSettors {
	flag: boolean;
}

export default function useFlag(on = false): IFlagHook {
	const [flag, setFlag] = useState(on);

	const set = useCallback(() => setFlag(true), []);
	const clear = useCallback(() => setFlag(false), []);
	const toggle = useCallback(() => setFlag(!flag), [flag]);
	const reset = useCallback(() => setFlag(on), []);

	return {
		flag,
		set,
		clear,
		toggle,
		reset,
	};
}
