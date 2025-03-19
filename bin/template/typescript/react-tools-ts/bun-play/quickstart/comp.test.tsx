import React from 'react';
import { describe, expect, test } from 'bun:test';
import { screen, render } from '@testing-library/react';
import { MyComponent } from './comp.tsx';

describe('<MyComponent /> tests', () => {
  test('Can use Testing Library', () => {
    render(<MyComponent message="MESSAGE" />);

    const myComponent = screen.getByTestId('my-component');
    expect(myComponent).toBeInTheDocument();
    expect(screen.getByText('MESSAGE')).toBeInTheDocument();
  })
}); // describe <MyComponent />
