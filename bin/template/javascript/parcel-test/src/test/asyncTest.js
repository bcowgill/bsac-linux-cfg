// eslint-disable-next-line no-console
const warn = console.warn

/*
	Example of how to perform an asynchronous test so that failed expects actually
	show the error result instead of just Timeout - Async callback was not invoked

	it('should be test', function testIt(asyncDone) {

		const expectations = asyncTest(
			`${suite} › sub suite › should be test`,
			asyncDone,
			(...rest) => {
				expect(somethingOutside).toEqual(somethingExpected);
				expect(rest).toEqual(['parameters of callback']);
			});

		do_something_async_and_callback(expectations);
	});
*/
export default function asyncTest(description, asyncDone, fnTest) {
	return (...rest) => {
		// quite a bit needed here to actually show the failing test instead of
		// just saying Timeout - Async callback was not invoked
		// we try to make the output look as much like a normal failing test as we can.
		let error
		try {
			fnTest(...rest)
		} catch (exception) {
			// istanbul ignore next
			error = exception
			// istanbul ignore next
			warn(`● ${description}\n${error.toString()}`)
		}
		// istanbul ignore next
		if (error) {
			throw error
		}
		asyncDone()
	}
}

/*
	Example of how to perform an asynchronous Promise rejection test so that failed
	expects actually show the error result instead of just
	Timeout - Async callback was not invoked

	it('should be test', function testIt(asyncDone) {

		expectPromiseReject(
			`${suite} › sub suite › should be test`,
			asyncDone,
			do_something_that_returns_a_promise(), // window.fetch() for example
			(reason) => {
				expect(reason).toBe(rejectionReason);
			});
	});
*/
export function expectPromiseReject(description, asyncDone, promise, fnTest) {
	// quite a bit needed here to actually show the failing test instead of
	// just saying Timeout - Async callback was not invoked
	// we try to make the output look as much like a normal failing test as we can.
	promise
		.then(
			// istanbul ignore next
			(response) => {
				try {
					expect(response).toBe(
						'Promise should have rejected with reason, but resolved instead'
					)
				} catch (error) {
					warn(`● ${description}\n${error.toString()}`)
				}
				return response
			}
		)
		.catch((reason) => {
			try {
				fnTest(reason)
				asyncDone()
			} catch (error) {
				// istanbul ignore next
				warn(`● ${description}\n${error.toString()}`)
			}
		})
}

/*
	Example of how to perform an asynchronous Promise resolution test so that failed
	expects actually show the error result instead of just
	Timeout - Async callback was not invoked

	it('should be test', function testIt(asyncDone) {

		expectPromiseResolves(
			`${suite} › sub suite › should be test`,
			asyncDone,
			do_something_that_returns_a_promise(), // window.fetch() for example
			(result) => {
				expect(result).toBe(resolveResult);
			});
	});
*/
export function expectPromiseResolves(description, asyncDone, promise, fnTest) {
	// quite a bit needed here to actually show the failing test instead of
	// just saying Timeout - Async callback was not invoked
	// we try to make the output look as much like a normal failing test as we can.
	promise
		.then((response) => {
			try {
				fnTest(response)
				asyncDone()
			} catch (error) {
				// istanbul ignore next
				warn(`● ${description}\n${error.toString()}`)
			}
			return response
		})
		.catch(
			// istanbul ignore next
			(reason) => {
				try {
					expect(reason).toBe(
						'Promise should have resolved with a response, but rejected instead'
					)
				} catch (error) {
					warn(`● ${description}\n${error.toString()}`)
				}
			}
		)
}
