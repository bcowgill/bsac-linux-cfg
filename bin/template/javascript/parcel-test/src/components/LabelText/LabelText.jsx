// LabelText React component to present a labelled text input field
// See the specs for details:
// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label
// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
import React from 'react'
import PropTypes from 'prop-types'
import PropTypesStyle from 'react-style-proptype'
import warnError from '../../util/prop-errors'

const displayName = 'LabelText'

const ariaPropTypes = {
	// WAI-ARIA props for accessibility
	role: PropTypes.string,
	ariaLabel: PropTypes.string, // if no visible label this can be used
	idAriaLabelledby: PropTypes.string, // if no visible label this has priority over ariaLabel
	idAriaDescribedby: PropTypes.string, // id of element containing longer description
	idAriaDetails: PropTypes.string, // id of elements containg much more details
	idAriaErrorMessage: PropTypes.string, // id of element showing error messagd when invalid
}

const nonStandardPropTypes = {
	// ns = non-standard
	nsAutoCorrect: PropTypes.oneOf(['on', 'off']), // safari
	nsIncremental: PropTypes.bool, // safari and chrome
	nsActionHint: PropTypes.oneOf(['go', 'done', 'next', 'search', 'send']), // mozilla mobile virtual keyboard Enter key
	nsResults: PropTypes.number, // safari
	nsErrorMessage: PropTypes.string, // mozilla
}

const propTypes = {
	// basic identity and form of the text input
	id: PropTypes.string.isRequired,
	idForm: PropTypes.string,
	className: PropTypes.string,
	type: PropTypes.oneOf(['text', 'email', 'password', 'search', 'tel', 'url']),
	inputMode: PropTypes.oneOf([
		'none',
		'text',
		'decimal',
		'numeric',
		'tel',
		'search',
		'email',
		'url',
	]), // mobile virtual keyboard type
	tabindex: PropTypes.number,

	// labelling and values
	label: PropTypes.string,
	placeholder: PropTypes.string,
	value: PropTypes.string.isRequired,
	autoComplete: PropTypes.string, // off, on, name. etc... see input spec url above
	idDataList: PropTypes.string,

	// on/off properties
	disabled: PropTypes.bool,
	readOnly: PropTypes.bool,
	required: PropTypes.bool,
	multiple: PropTypes.bool,
	invalid: PropTypes.bool,

	// string validation
	minLength: PropTypes.number,
	maxLength: PropTypes.number,
	pattern: PropTypes.instanceOf(RegExp), // will match against entire value
	spellCheck: PropTypes.oneOfType([
		PropTypes.oneOf(['default']),
		PropTypes.bool,
	]),

	// number validation
	min: PropTypes.number,
	max: PropTypes.number,
	step: PropTypes.oneOfType([PropTypes.oneOf(['any']), PropTypes.number]),

	...ariaPropTypes,
	...nonStandardPropTypes,

	// style related
	charSize: PropTypes.number,
	style: PropTypes.shape({
		label: PropTypesStyle,
		input: PropTypesStyle,
	}),
}

const defaultProps = {
	idForm: undefined,
	className: '',
	type: 'text',
	inputMode: undefined,
	tabindex: undefined,
	label: '',
	placeholder: undefined,
	autocomplete: 'off',
	idDataList: undefined,
	disabled: false,
	readOnly: false,
	required: false,
	multiple: false,
	invalid: false,
	minLength: undefined,
	maxLength: undefined,
	pattern: undefined,
	spellCheck: false,
	role: undefined,
	ariaLabel: undefined,
	idAriaLabelledby: undefined,
	idAriaDescribedby: undefined,
	idAriaDetails: undefined,
	idAriaErrorMessage: undefined,
	nsAutoCorrect: undefined,
	nsIncremental: undefined,
	nsIncremental: undefined,
	nsActionHint: undefined,
	nsResults: undefined,
	nsErrorMessage: undefined,
	min: undefined,
	max: undefined,
	step: undefined,
	charSize: 20,
	style: undefined,
}

function getInputMode(props) {
	const type = props.type
	let inputMode = props.inputMode

	if (/^(tel|email|url)$/.test(type)) {
		inputMode = undefined
	}
	return inputMode
}

function multipleValues(props) {
	return props.type === 'email' && props.multiple
}

// convert RegExp to regex string minus the slashes and ensure ^$ to match entire value.
function getPattern(props) {
	let pattern = undefined
	if (
		typeof props.pattern === 'object' &&
		props.pattern.constructor === RegExp
	) {
		pattern = props.pattern
			.toString()
			.replace(/\$?\/[a-z]*$/, '$')
			.replace(/^\/\^?/, '^')
	}
	return pattern
}

function getCharSize(props) {
	let charSize = undefined

	if (props.charSize && props.charSize !== 20) {
		charSize = props.charSize
	}
	return charSize
}

function incremental(props) {
	let incremental = undefined

	if (props.type === 'search') {
		incremental = props.nsIncremental
	}
	return incremental
}

function results(props) {
	let results = undefined
	if (props.type === 'search') {
		results = props.nsResults
	}
	return results
}

function empty(value) {
	return !(value && value.trim().length)
}

// https://developer.mozilla.org/en-US/search?q=aria
// https://www.w3.org/TR/wai-aria-1.1/#role_definitions
// https://www.w3.org/TR/wai-aria-1.1/#state_prop_def
function ariaProps(props) {
	const role =
		props.role || (props.type === 'search' ? 'searchbox' : 'textbox')
	let ariaLabel
	let ariaLabelledby
	if (!empty(props.label)) {
		// label is visible
		ariaLabelledby = props.id
	} else {
		// label is not visible on screen
		ariaLabelledby = props.idAriaLabelledby
	}
	ariaLabel = ariaLabelledby ? undefined : props.ariaLabel

	return {
		role,
		'aria-label': ariaLabel,
		'aria-labelledby': ariaLabelledby,
		'aria-placeholder': props.placeholder,
		'aria-describedby': props.idAriaDescribedby,
		'aria-details': props.idAriaDetails,
		'aria-required': props.required,
		'aria-readonly': props.readonly,
		'aria-invalid': props.invalid,
		'aria-errormessage': props.idAriaErrorMessage,
		'aria-multiline': false,
	}
}

const propWarnings = {
	label(props) {
		return `Failed prop combination: One of these props: \`label\`, \`ariaLabel\`, \`idAriaLabelledby\` is required in \`${displayName}\`, but none were provided.`
	},
}

export function warnPropErrors(props, konsole) {
	/* istanbul ignore next */
	if (process.env.NODE_ENV !== 'production') {
		if (empty(props.label)) {
			if (empty(props.idAriaLabelledby) && empty(props.ariaLabel)) {
				warnError(displayName, 'label', props, propWarnings, konsole)
			}
		}
	}
}

export default function LabelText(props) {
	warnPropErrors(props)
	const idInput = `txt${props.id.replace(/^lbl/, '')}`
	const inputMode = getInputMode(props)
	const multiple = multipleValues(props)
	const pattern = getPattern(props)
	const charSize = getCharSize(props)
	const nsIncremental = incremental(props)
	const nsResults = results(props)
	const aria = ariaProps(props)

	return (
		<label
			id={props.id}
			className={[displayName, props.className].join(' ').trim()}
			htmlFor={idInput}
			form={props.idForm}
			style={props.style && props.style.label}
		>
			{props.label}
			<input
				id={idInput}
				name={idInput}
				type={props.type}
				inputMode={inputMode}
				value={props.value}
				autoComplete={props.autoComplete}
				list={props.idDataList}
				disabled={props.disabled}
				readOnly={props.readOnly}
				required={props.required}
				multiple={multiple}
				minLength={props.minLength}
				maxLength={props.maxLength}
				pattern={pattern}
				spellCheck={props.spellCheck}
				autoCorrect={props.nsAutoCorrect}
				incremental={nsIncremental}
				mozactionhint={props.nsActionHint}
				x-moz-errormessage={props.nsErrorMessage}
				results={nsResults}
				min={props.min}
				max={props.max}
				step={props.step}
				size={charSize}
				style={props.style && props.style.input}
				{...aria}
			/>
		</label>
	)
}
LabelText.displayName = displayName
LabelText.propTypes = propTypes
LabelText.defaultProps = defaultProps
