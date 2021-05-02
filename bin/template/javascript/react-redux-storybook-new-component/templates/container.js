import { connect } from 'react-redux'
import { someAction } from '../src/actions'
import Component from './'

// use reselect module to memoize the prop maps if performance
// is an issue: https://redux.js.org/recipes/computing-derived-data
/* (state, ownProps) */
const mapStateToProps = (state) => ({
	someProp: state.someState,
})

/* (dispatch, ownProps) */
const mapDispatchToProps = (dispatch) => ({
	onSomeEvent: (payload) => {
		dispatch(someAction(payload))
	},
})

const Container = connect(
	mapStateToProps,
	mapDispatchToProps
)(Component)

export default Container
