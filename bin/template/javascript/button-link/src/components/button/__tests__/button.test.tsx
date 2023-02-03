import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import { Button } from '../button';

/*
  Test of ChatGPT writing React component unit tests.

  Tests:       2 failed, 5 passed, 7 total
    button.tsx    |     100 |    91.66 |     100 |     100 | 50-53

  Coverage very high but failed to write tests for default prop values, leaving three lines uncovered.
  Also 2 tests failed initially - it wrote getByTestId with the wrong expected testId values

  Then I manually fixed the tests, and wrote the additional tests to cover the lines, ending with:

  Tests:       11 passed, 11 total
    button.tsx    |     100 |      100 |     100 |     100 |  

  So had to write 4 more tests for full coverage.
  ChatGPT did 64% of the job for me.
  And there was actually a bug in the code which was discovered by the tests it had written.

 */

const displayName = 'Button';

describe(`${displayName} component`, () => {
  test('renders default text as a disabled button if nothing given', () => {
    const { getByTestId, getByText } = render(<Button/>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    expect(button).toHaveAttribute('data-component', `${displayName}-button`);
    expect(button).toBeDisabled();
    getByText('Ok');
  });

  test('renders as a button if no href is provided', () => {
    const { getByTestId, getByText } = render(<Button>Click me</Button>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    getByText('Click me');
  });

  test('renders as a submit button if inside a form', () => {
    const { getByTestId, getByText } = render(<Button type="submit">Submit</Button>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'submit');
    getByText('Submit');
  });

  test('disables button if disabled prop is provided', () => {
    const testId = 'BUTTON';
    const { getByTestId } = render(<Button disabled data-testid={testId}>Click me</Button>);
    const button = getByTestId(testId);

    expect(button).toBeDisabled();
  });

  test('additional props pass through to button', () => {
    const testId = 'BUTTON';
    const { getByTestId } = render(<Button disabled aria-label="Button" data-testid={testId}>Click me</Button>);
    const button = getByTestId(testId);

    expect(button).toHaveAttribute('aria-label', 'Button');
    expect(button).toHaveAttribute('class' , 'root');
  });

  test('renders as a link if href is provided', () => {
    const testId = 'LINK';
    const { getByTestId, getByText } = render(<Button href="#" data-testid={testId}>Go to</Button>);
    const link = getByTestId(testId);

    expect(link.tagName).toBe('A');
    getByText('Go to');
  });

  test('renders an internal arrow if href points to an internal page', () => {
    const testId = 'LINK';
    const { getByTestId } = render(<Button href="#" data-testid={testId}>Go to</Button>);
    const internalArrow = getByTestId(`${testId}-link-internal`);

    expect(internalArrow).toBeInTheDocument();
  });

  test('renders an external arrow if href points to an external page', () => {
    const { getByTestId } = render(<Button href="https://example.com" target="_blank">Go to</Button>);
    const externalArrow = getByTestId(`${displayName}-link-external`);

    expect(externalArrow).toBeInTheDocument();
  });

  test('additional props pass through to link', () => {
    const { getByTestId } = render(<Button aria-label="List" href="/">Go to</Button>);
    const button = getByTestId(displayName);

    expect(button).toHaveAttribute('aria-label', 'List');
    expect(button).toHaveAttribute('class' , 'link root');
  });

  test('fires onClick event if provided', () => {
    const handleClick = jest.fn();
    const { getByTestId } = render(<Button onClick={handleClick}>Click me</Button>);
    const button = getByTestId(displayName);

    fireEvent.click(button);

    expect(handleClick).toHaveBeenCalled();
  });
});


