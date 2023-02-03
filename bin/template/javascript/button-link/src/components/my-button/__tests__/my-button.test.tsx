import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import { MyButton as Component } from '../my-button';

const displayName = 'MyButton';

describe(`${displayName} component`, () => {
  const space = {
    charCode: 32,
    code: "Space",
    key: " ",
    keyCode: 32,
    which: 32,
    ctrlKey: false,
    metaKey: false,
    altKey: false,
    shiftKey: false
  };

  test('renders default text as a disabled button if nothing given', () => {
    const { getByTestId, getByText } = render(<Component/>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    expect(button).toHaveAttribute('data-component', `${displayName}-button`);
    expect(button).toBeDisabled();
    getByText('Ok');
  });

  test('renders as a button if no href is provided', () => {
    const { getByTestId, getByText } = render(<Component>Click me</Component>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    getByText('Click me');
  });

  test('renders as a submit button if inside a form', () => {
    const { getByTestId, getByText } = render(<Component type="submit">Submit</Component>);
    const button = getByTestId(displayName);

    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'submit');
    getByText('Submit');
  });

  test('disables button if disabled prop is provided', () => {
    const testId = 'BUTTON';
    const { getByTestId } = render(<Component disabled data-testid={testId}>Click me</Component>);
    const button = getByTestId(testId);

    expect(button).toBeDisabled();
  });

  test('additional props pass through to button', () => {
    const testId = 'BUTTON';
    const { getByTestId } = render(<Component disabled aria-label="Button" data-testid={testId}>Click me</Component>);
    const button = getByTestId(testId);

    expect(button).toHaveAttribute('aria-label', 'Button');
    expect(button).toHaveAttribute('class' , 'button root');
  });

  test('renders as a link if href is provided', () => {
    const testId = 'LINK';
    const { getByTestId, getByText } = render(<Component href="#" data-testid={testId}>Go to</Component>);
    const link = getByTestId(testId);

    expect(link.tagName).toBe('A');
    getByText('Go to');
  });

  test('renders as a link without rel if target missing and if href is provided', () => {
    const testId = 'LINK';
    const { getByTestId, getByText } = render(<Component href="#" data-testid={testId} rel="alternate">Go to</Component>);
    const link = getByTestId(testId);

    expect(link.tagName).toBe('A');
    expect(link).not.toHaveAttribute('rel');
  });

  test('renders as a link with target and rel if href is provided', () => {
    const testId = 'LINK';
    const { getByTestId, getByText } = render(<Component href="#" data-testid={testId} target="_blank" rel="alternate">Go to</Component>);
    const link = getByTestId(testId);

    expect(link.tagName).toBe('A');
    expect(link).toHaveAttribute('rel', 'alternate');
  });

  test('additional props pass through to link', () => {
    const { getByTestId } = render(<Component aria-label="List" href="/">Go to</Component>);
    const button = getByTestId(displayName);

    expect(button).toHaveAttribute('aria-label', 'List');
    expect(button).toHaveAttribute('class' , 'link root');
  });

  test('fires onClick event if provided', () => {
    const handleClick = jest.fn();
    const { getByTestId } = render(<Component onClick={handleClick}>Click me</Component>);
    const button = getByTestId(displayName);

    fireEvent.click(button);

    expect(handleClick).toHaveBeenCalled();
  });

  test('fires onNavigateTo event if provided and Space up happens on link', () => {
    const handleNavigateTo = jest.fn();
    const { getByTestId } = render(<Component href="/" onNavigateTo={handleNavigateTo}>Go to</Component>);
    const link = getByTestId(displayName);

    fireEvent.keyDown(link, space);
    fireEvent.keyUp(link, space);

    fireEvent.keyDown(link, { ...space, shiftKey: true });
    fireEvent.keyUp(link, { ...space, shiftKey: true });

    fireEvent.keyDown(link, { ...space, ctrlKey: true });
    fireEvent.keyUp(link, { ...space, ctrlKey: true });

    expect(handleNavigateTo).toHaveBeenCalledTimes(3);
  });

  test('doest NOT fire onNavigateTo event if provided and Meta or Alt-Space up happens on link', () => {
    const handleNavigateTo = jest.fn();
    const { getByTestId } = render(<Component href="/" onNavigateTo={handleNavigateTo}>Go to</Component>);
    const link = getByTestId(displayName);

    fireEvent.keyDown(link, { ...space, altKey: true });
    fireEvent.keyUp(link, { ...space, altKey: true });

    fireEvent.keyDown(link, { ...space, metaKey: true });
    fireEvent.keyUp(link, { ...space, metaKey: true });

    expect(handleNavigateTo).not.toHaveBeenCalled();
  });
});


