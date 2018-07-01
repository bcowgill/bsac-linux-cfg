   import React from 'react';
   import renderer from 'react-test-renderer';

   import LabelText from './';

   const suite = 'src/components/ <LabelText> component';
   const noop = function () { };

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

	  describe( 'property warning tests',
		 function descLabelTextPropWarningSuite()
		 {
			it.skip( 'should emit a warning if not labelled properly', noop );
			it.skip( 'should not emit the same warning more than once', noop );
		 } ); // property warning tests

	  describe( 'render snapshot tests',
		 function descLabelTextSnapshotSuite()
		 {

			it( 'should render with minimal properties',
			   function testLabelTextRenderMinimal()
			   {
				  const component = buildComponent( {
					 label: 'LABEL',
				  } );
				  const tree = component.toJSON();
				  expect( tree ).toMatchSnapshot();
			   } );

			it.skip( 'should render with empty label and aria label', noop );
			it.skip( 'should render with empty label and aria lable + labelby', noop );
			it.skip( 'should render type tel or url to suppress inputMode', noop );
			it.skip( 'should render type email to suppress inputMode and allow multiple values', noop );
			it.skip( 'should render with pattern to parse regex properly', noop );
			it.skip( 'should render with charSize prop not default of 20', noop );
			it.skip( 'should render type search with non standard browser props', noop );
			it.skip( 'should render with all props', noop );
		 } ); // render snapshot tests

	  describe( 'style override tests',
		 function descLabelTextStyleSuite()
		 {
			it.skip( 'should render with styles object', noop );
		 } ); // style override tests

	  describe( 'component behaviour tests',
		 function descLabelTextBehaviourSuite()
		 {
			it.skip( 'should handle a user change to the text', noop );
		 } ); // component behaviour tests
   } );
