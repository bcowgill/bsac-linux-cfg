//import React from 'react';
import type { ReactElement } from 'react';

//console.log("comp.tsx: Hello via Cross Bun!", Bun.version);

export interface MyComponentProps{ message: string }
export function MyComponent(props: MyComponentProps): ReactElement<MyComponentProps> {
  return (
    <main data-testid="my-component">
      <h1 style={{color: 'red'}}>{props.message}</h1>
    </main>
  );
}

//console.log(`comp.tsx logging a component looks cool:`, <MyComponent message="Hello world!" />);

