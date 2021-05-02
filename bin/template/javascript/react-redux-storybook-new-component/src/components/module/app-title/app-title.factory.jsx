// A factory for creating the component for storybook or unit tests
import React from 'react'
import { action } from '@storybook/addon-actions'
import TestComponent from './'

export const Component = TestComponent

export const displayName = TestComponent.displayName

// Make default minimal props (all required prop types)
export const makeMinimalProps = (
	title = ':APP TITLE:',
	error = false,
	onChangeClientState = action('change_state')
) => ({ title, error, onChangeClientState })

// Make with full props
export const makeFullProps = (
	title,
	error = false,
	defaultTitle = 'DEFAULT TITLE',
	titleTemplate = `%s | ${defaultTitle}`,
	onChangeClientState = action('change_state')
) => ({ title, error, defaultTitle, titleTemplate, onChangeClientState })

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

// Make the component with full props
export const makeFull = (...args) => buildComponent(makeFullProps(...args))

// For unit tests make component with minimal props and extend with additional props
export const wrap = (Comp) => (
	<div>
		<h1>
			Examine the &lt;head&gt;&lt;title&gt; of this document to see the results.
		</h1>
		{Comp}
	</div>
)
