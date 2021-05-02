import { connect } from 'react-redux'
import Component from './'

const mapStateToProps = (state) => ({
	title: state.app.title,
	error: state.app.errors.length > 0,
})

const AppTitleContainer = connect(mapStateToProps)(Component)

export default AppTitleContainer
