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
			function snapshotTest( props )
			{
			   const component = buildComponent( props );
			   const tree = component.toJSON();
			   expect( tree ).toMatchSnapshot();
			   return component;
			}

			it( 'should render with minimal properties',
			   function testLabelTextRenderMinimal()
			   {
				  snapshotTest( {
					 label: 'LABEL',
				  } );
			   } );

			it( 'should render with aria label and empty label',
			   function testLabelTextAriaLabel()
			   {
				  snapshotTest( {
					 ariaLabel: 'ARIA LABEL',
				  } );
			   } );

			it( 'should render with aria label + labelby and empty label',
			   function testLabelTextAriaLabelledby()
			   {
				  snapshotTest( {
					 ariaLabel: 'ARIA LABEL',
					 idAriaLabelledby: 'ID-ARIA-LABELLEDBY',
					 inputMode: 'decimal',
					 multiple: true, // ignored unless email
				  } );
			   } );

			it( 'should render type tel or url to suppress inputMode and multiple',
			   function testLabelTextTel()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 type: 'tel',
					 inputMode: 'tel', // will be ignored for tel
					 multiple: true, // ignored for tel
				  } );
			   } );

			it( 'should render type email to suppress inputMode and allow multiple values',
			   function testLabelTextEmail()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 type: 'email',
					 inputMode: 'email', // will be ignored for email
					 multiple: true,
				  } );
			   } );

			it( 'should render with pattern to parse regex properly',
			   function testLabelTextPattern()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 pattern: /start(.+)end/,
				  } );
			   } );

			it( 'should render with pattern that has ^ $ in it',
			   function testLabelTextPattern()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 pattern: /^start(.+)end$/,
				  } );
			   } );

			it( 'should render with charSize prop not default of 20',
			   function testLabelTextCharSize()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 charSize: 44,
				  } );
			   } );

			it( 'should render type not search with non standard browser props - ignored',
			   function testLabelTextNotSearchNonStandard()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 type: 'url',
					 nsAutoCorrect: 'on',
					 nsIncremental: true,
					 nsActionHint: 'go',
					 nsResults: 5,
					 nsErrorMessage: 'NON-STANDARD ERROR MESSAGE',
				  } );
			   } );

			it( 'should render type search with non standard browser props',
			   function testLabelTextSearchNonStandard()
			   {
				  snapshotTest( {
					 label: 'LABEL',
					 type: 'search',
					 nsAutoCorrect: 'on',
					 nsIncremental: true,
					 nsActionHint: 'go',
					 nsResults: 5,
					 nsErrorMessage: 'NON-STANDARD ERROR MESSAGE',
				  } );
			   } );

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
