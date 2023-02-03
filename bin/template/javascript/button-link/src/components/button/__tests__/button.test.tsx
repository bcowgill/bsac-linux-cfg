import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  test('renders as a button if no href is provided', () => {
    const { getByTestId } = render(<Button data-testid="button">Click me</Button>);
    const button = getByTestId('button');

    expect(button.tagName).toBe('BUTTON');
  });

  test('renders as a link if href is provided', () => {
    const { getByTestId } = render(<Button href="#" data-testid="link">Go to</Button>);
    const link = getByTestId('link');

    expect(link.tagName).toBe('A');
  });

  test('renders an internal arrow if href points to an internal page', () => {
    const { getByTestId } = render(<Button href="#" data-testid="link">Go to</Button>);
    const internalArrow = getByTestId('Button-link-internal');

    expect(internalArrow).toBeInTheDocument();
  });

  test('renders an external arrow if href points to an external page', () => {
    const { getByTestId } = render(<Button href="https://example.com" target="_blank" data-testid="link">Go to</Button>);
    const externalArrow = getByTestId('Button-link-external');

    expect(externalArrow).toBeInTheDocument();
  });

  test('disables button if disabled prop is provided', () => {
    const { getByTestId } = render(<Button disabled data-testid="button">Click me</Button>);
    const button = getByTestId('button');

    expect(button).toBeDisabled();
  });

  test('fires onClick event if provided', () => {
    const handleClick = jest.fn();
    const { getByTestId } = render(<Button onClick={handleClick} data-testid="button">Click me</Button>);
    const button = getByTestId('button');

    fireEvent.click(button);

    expect(handleClick).toHaveBeenCalled();
  });
});

