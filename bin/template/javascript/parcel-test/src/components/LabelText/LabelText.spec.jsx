   import React from 'react';
   import renderer from 'react-test-renderer';

   import LabelText from './';

   const suite = 'src/components/ <LabelText> component';

   describe( suite, function descLabelTextSuite()
   {
	  function buildComponent( props )
	  {
		 const mergedProps = {
			id: 'ID',
			value: 'VALUE',
			...props,
		 };
		 const component = renderer.create(
			<LabelText
			   {...mergedProps}
			/>,
		 );
		 return component;
	  }

	  it( 'should render with minimal properties',
		 function testLabelTextRenderMinimal()
		 {
			const component = buildComponent( {
			   label: 'LABEL',
			} );
			const tree = component.toJSON();
			expect( tree ).toMatchSnapshot();
		 } );
   } );
