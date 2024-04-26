import React from 'react'

const displayName = 'App'

function App() {
	return (
		<div>
			{/* singleAttributePerLine check */}
			<h1 id="H" class="C">
				HEADING
			</h1>
			{/* jsxSingleQuote bracketSameLine check */}
			<input
				type="text"
				className={displayName.toLowerCase()}
				id={`${displayName}-long-id-param`}
				name={`${displayName}-name`}
				data-testid={`${displayName}-testid`}
			/>
			{/* htmlWhitespaceSensitivity check */}
			<p>
				{' '}
				1<b> 2 </b>3
			</p>
			<p>
				1<b>2</b>3
			</p>
		</div>
	)
}
App.displayName = displayName

export default App
