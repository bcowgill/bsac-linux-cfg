   import React from 'react';
   import renderer from 'react-test-renderer';
   import LabelText from './';
   import { warnPropErrors } from './';

   const suite = 'src/components/ <LabelText> component';

   const noop = function () { };

   const mockStyle = {
	  label: {
		 content: '"MOCK STYLE LABEL"',
	  },
	  input: {
		 font: '"MOCK STYLE INPUT"',
	  },
   };

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
			it( 'should emit a warning if not labelled properly -- only once',
			   function testLabelTextPropWarn()
			   {
				  const spy = jest.fn().mockReturnValue( 1 );
				  warnPropErrors( {}, { error: spy } );
				  expect( spy ).toHaveBeenCalledTimes( 1 );
				  expect( spy ).toHaveBeenCalledWith(
					 "Warning: Failed prop combination: One of these props: `label`, `ariaLabel`, `idAriaLabelledby` is required in `LabelText`, but none were provided.\n    in LabelText"
				  );

				  warnPropErrors( {}, { error: spy } );
				  warnPropErrors( {}, { error: spy } );
				  expect( spy ).toHaveBeenCalledTimes( 1 );
			   } );
		 } ); // property warning tests

	  describe( 'render snapshot tests',
		 function descLabelTextSnapshotSuite()
		 {
			// http://jestjs.io/docs/en/snapshot-testing.html#content
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
			   function testLabelTextPatternCaretDollar()
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

			it( 'should render with all props',
			   function testLabelTextRenderAllProps()
			   {
				  snapshotTest( {
					 idForm: 'ID-FORM',
					 className: 'CSS-CLASS',
					 type: 'text',
					 inputMode: 'numeric',
					 tabindex: 99,
					 label: 'LABEL',
					 placeholder: 'PLACEHOLDER',
					 value: '01',
					 autoComplete: 'off',
					 idDataList: 'ID-DATALIST',
					 disabled: false,
					 readOnly: false,
					 required: true,
					 multiple: false,
					 invalid: false,
					 minLength: 2,
					 maxLength: 12,
					 pattern: /0+[0-9]+/,
					 spellCheck: false,
					 min: 1,
					 max: 123456789012,
					 step: 5,
					 charSize: 13,
					 style: mockStyle,
					 role: 'search',
					 ariaLabel: 'ARIA LABEL',
					 idAriaLabelledby: 'ID-ARIA-LABELLEDBY',
					 idAriaDescribedby: 'ID-ARIA-DESCRIBEDBY',
					 idAriaDetails: 'ID-ARIA-DETAILS',
					 idAriaErrorMessage: 'ID-ARIA-ERROR-MESSAGE',
					 nsAutoCorrect: 'off',
					 nsIncremental: false,
					 nsActionHint: 'send',
					 nsResults: 4,
					 nsErrorMessage: 'NON-STANDARD ERROR MESSAGE',
				  } );
			   } );
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
