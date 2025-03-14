// useWindowSize.ts - re-render on window size change giving sizes, zoom level and user description

import { useLayoutEffect, useState } from "react";

const SCROLLBAR_WIDTH = 10;

export interface IWindowSize {
	width: number;
	height: number;
}

export interface IWindowGeometry {
	info: string; // all info in a string friendly to the user.
	zoomLevel: number; // approximate percentage zoom level.  Only if devtools are closed/undocked or docked to top/bottom.
	zoomLevelV: number; // approximate vertical percentage zoom level.  Only if devtools are closed/undocked or docked to right/left.
	inner: IWindowSize; // effective CSS pixels as given by zoom level.
	outer: IWindowSize; // physical pixels for outer window, excludes zoom.
}

function calcZoom(inner: number, outer: number): number {
	let zoom = Math.round(((outer - SCROLLBAR_WIDTH) / inner) * 20) * 5;
	if (inner === outer) {
		zoom = 100;
	}
	return zoom;
}

export function getWindowGeometry(win = window): IWindowGeometry {
	// Zoom levels are rounded to the nearest 5% due to their approximation.
	const zoomLevel = calcZoom(win.innerWidth, win.outerWidth);
	const zoomLevelV = calcZoom(win.innerHeight, win.outerHeight);
	let size = `${win.innerWidth}x${win.innerHeight}i ${win.outerWidth}x${win.outerHeight}o`;
	let zoom = `${zoomLevel}%H ${zoomLevelV}%V`
	if (zoomLevel === zoomLevelV) {
		zoom = `${zoomLevel}%`;
		if (zoomLevel === 100) {
			size = `${win.innerWidth}x${win.innerHeight}`;
		}
	}
	return {
		info: `${size} ${zoom}`,
		zoomLevel,
		zoomLevelV,
		inner: {
			width: win.innerWidth,
			height: win.innerHeight,
		},
		outer: {
			width: win.outerWidth,
			height: win.outerHeight,
		},
	};
} // getWindowGeometry()

/**
 * a hook which answers with the current window geometry after a window size change.
 * @returns {IWindowGeometry} the current window geometry, inner/outer sizes. zoom levels H/V and a developer friendly info message.
 * @note The zoom level calculations are approximate due to different browser scroll bar sizes and if you have
 * the developer tools open and docked to an edge that side will be very wrong.
 */
export function useWindowSize() {
	const [windowSize, setWindowSize] = useState<IWindowGeometry>(getWindowGeometry());

	useLayoutEffect(function whenWeMount() {
		function updateWindowSize() {
			setWindowSize(getWindowGeometry());
		}

		window.addEventListener("resize", updateWindowSize);

		return function whenWeUnMount() {
			window.removeEventListener("resize", updateWindowSize);
		}
	}, []); // empty dependency array for mount/unmount

	return windowSize;
} // useWindowSize()
