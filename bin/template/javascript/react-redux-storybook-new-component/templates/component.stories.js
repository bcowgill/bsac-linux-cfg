import { storiesOf } from '@storybook/react'
import * as TestFactory from './TEMPLATEFILENAME.factory'

storiesOf('TEMPLATESTORYPATH/ TEMPLATEOBJNAME', module)
	.add('minimal props', () => TestFactory.makeMinimal('TITLE'))
	.add('with unicode', () => TestFactory.makeMinimal('😀 😎 👍 💯'))
