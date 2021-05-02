import { storiesOf } from '@storybook/react'
import * as TestFactory from './app-title.factory'

storiesOf('module/ AppTitle', module)
	.add('minimal props', () =>
		TestFactory.wrap(TestFactory.makeMinimal('TITLE'))
	)
	.add('with full props', () =>
		TestFactory.wrap(TestFactory.makeFull('FULL TITLE'))
	)
	.add('with full props no title uses default', () =>
		TestFactory.wrap(TestFactory.makeFull())
	)
	.add('error state minimal', () =>
		TestFactory.wrap(TestFactory.makeMinimal(undefined, true))
	)
	.add('error state no title uses default', () =>
		TestFactory.wrap(TestFactory.makeFull(undefined, true))
	)
	.add('error state full', () =>
		TestFactory.wrap(TestFactory.makeFull('FULL TITLE', true))
	)
