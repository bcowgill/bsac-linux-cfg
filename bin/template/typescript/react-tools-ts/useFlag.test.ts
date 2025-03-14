import { renderHook, act } from '@testing-library/react-hooks'
import useHook from './useFlag'

describe('useFlag hook', function descUseFlagSuite() {
	function renderForTest(on?: boolean) {
		const { result } = renderHook( () => useHook(on) )
		return result;
	}

	function change(ref, mutator: string, expected: boolean) {
		act(ref.current[mutator])
		expect(ref.current.flag).toBe(expected)
	}

	it('should provide flag and setter functions for default flag is not "on"', function testUseFlagDefault() {
		const hook = renderForTest();

		expect(hook.current.flag).toBe(false)

		change(hook, 'set', true)
		change(hook, 'set', true)
		change(hook, 'set', true)

		change(hook, 'clear', false)
		change(hook, 'clear', false)
		change(hook, 'clear', false)
		change(hook, 'set', true)
		change(hook, 'clear', false)

		change(hook, 'toggle', true)
		change(hook, 'toggle', false)
		change(hook, 'toggle', true)
		change(hook, 'toggle', false)
		change(hook, 'toggle', true)
		change(hook, 'toggle', false)
		change(hook, 'toggle', true)

		change(hook, 'reset', false)
		change(hook, 'reset', false)
	})

	it('should provide flag and setter functions for flag initially "on"', function testUseFlagOn() {
		const hook = renderForTest(true);

		expect(hook.current.flag).toBe(true)

		change(hook, 'set', true)
		change(hook, 'set', true)
		change(hook, 'set', true)

		change(hook, 'clear', false)
		change(hook, 'clear', false)
		change(hook, 'clear', false)
		change(hook, 'set', true)
		change(hook, 'clear', false)

		change(hook, 'toggle', true)
		change(hook, 'toggle', false)
		change(hook, 'toggle', true)
		change(hook, 'toggle', false)
		change(hook, 'toggle', true)
		change(hook, 'toggle', false)

		change(hook, 'reset', true)
		change(hook, 'reset', true)
	})
})
