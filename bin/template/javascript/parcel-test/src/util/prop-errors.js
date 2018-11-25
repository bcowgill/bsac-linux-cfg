export default function warnError(
	displayName,
	errorId,
	props,
	propWarnings,
	/*istanbul ignore next */
	konsole = console
) {
	if (propWarnings[errorId]) {
		konsole.error(
			`Warning: ${propWarnings[errorId](props)}\n    in ${displayName}`
		)
		delete propWarnings[errorId]
	}
}
