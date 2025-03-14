// diffState.ts - a poor man's version of Why Did You Render.
// https://github.com/welldone-software/why-did-you-render
// With hooks, all the component state is disperesed across various variables and functions, the idea of this is to useRef to store a common copy of all props/state values so that it can be diffed on every render to see what's changed.

// P is the type definition for the Component
// T is the type definition for all the combined useState/etc vars in the component
export interface PropsState<P,T> {
	props: P;
	internal: T;
}
export interface DiffState<P,T> {
	no: number;
	state: PropsState<P,T> | string;
};

/* Goes in your component's render function
	const render = useRef({ no: 0, state: '' });
	render.current.no = render.current.no + 1;
	const state = {
		props,
		internal: {
			...
			mode,
			setMode: brandFn(setMode, 'setMode'), // marks callback functions with a unique id
		},
	};
	type ComponentState = typeof state;
	diffState<ComponentProps,ComponentState>(displayName, render, state);
*/

// MUSTDO name should be taken from the callback function itself if possible, by stringify, .name, .displayName or mockName if it's a jest mock...
export function getFnName(_unusedCallback: any): string {
	return 'fnCallback';
}

let brandId = 0;
export function brandFn(callback: any, name?: string) {
	if (!callback._fnuid) {
		brandId++;
		callback._fnuid = brandId;
	}
	name = name || getFnName(callback);
	return `${name}#${callback._fnuid}()`;
}
export function diffState<P,T>(name: string, render: MutableRefObject<DiffState<P,T>>): void {
	const now = JSON.stringify(state, void 0, 2);
	if (now !== render.current.state) {
		const out = [];
		if (render.current.state === '') {
			out.push(now);
		} else {
			// TODO use line diff package of some kine if possible, this is very simple...
			const old = render.current.state.split(/\n/g);
			const chg = now.split(/\n/g);
			const length = old.length > chg.length ? old.length : chg.length;
			for (let idx = 0; idx < length; ++idx) {
				const was = `${old[idx]}`.trim();
				const is = `${chg[idx]}`.trim();
				if (was !== is) {
					out.push(`[${was}] => [${is}]`);
				}
			}
		}
		console.warn(
			`${name}.render #${render.current.no} change`,
			out.join('\n')
		);
	} else {
		console.warn(
			`${name}.render #${render.current.no} same`,
		);
	}
	render.current.state = now;
} // diffState()
