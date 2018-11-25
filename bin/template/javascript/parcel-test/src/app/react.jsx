import React from 'react'
import ReactDOM from 'react-dom'
import LabelText from '../components/LabelText'
import '../styles/styles.scss'

const App = () => (
	<section>
		<h1>Hello ALL from React and parcel!</h1>
		{/* prettier-ignore */}
		<LabelText
			id="ID"
			value="VALUE"
			label="LABEL"
			readOnly={true}
		/>
	</section>
)
App.displayName = 'App'

const rootDiv = document.getElementById('root')
ReactDOM.render(<App />, rootDiv)
