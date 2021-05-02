// A factory for creating the component for storybook or unit tests
import React from 'react'
import { action } from '@storybook/addon-actions'
import TestComponent from './'

export const Component = TestComponent

export const displayName = TestComponent.displayName

// Make default minimal props (all required prop types)
export const makeMinimalProps = (
	title = 'TITLE',
	id = `ID_${title}`,
	onClick = action('clicked')
) => ({ id, title, onClick })

// Make all props for the component with appropriate defaults
export const makeFullProps = (
	title = 'TITLE',
	id = `ID_${title}`,
	onClick = action('clicked')
) => ({ id, title, onClick })

// For unit tests make component with minimal props and extend with additional props
export const buildComponent = (props = {}) => {
	const mergedProps = {
		...makeMinimalProps(),
		...props,
	}
	return <TestComponent {...mergedProps} />
}

// Make the component with default minimal props (all required prop types)
export const makeMinimal = (...args) =>
	buildComponent(makeMinimalProps(...args))

// Make the component with all allowed properties
export const makeFull = (...args) => buildComponent(makeFullProps(...args))
