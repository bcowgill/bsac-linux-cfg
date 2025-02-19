   //==========================================================
   // Regex tests to validate it's working...

   expectToMatch( reVersionNickname, '<span>  version.nickname: blah blah </span>', 'reVersionNickname should match the nickname text' );
   expectNotToMatch( reVersionNickname, '<span>  version.Nickname: blah blah </span>', 'reVersionNickname should NOT match wrong case' );
   expectNotToMatch( reVersionNickname, '<span>  version not nickname blah blah </span>', 'breVersionNickname should NOT match non-nickname text' );

   expectToMatch( reAllowId, 'csl-dialog-desc12', 'reAllowId should match allowed id value', 2 );
   expectNotToMatch( reAllowId, 'csl-dialog-desc', 'reAllowId should NOT match other id values' );

   expectToMatch( reAttrsBoolean, 'xx  focusable="false"', 'reAttrsBoolean should match allowed boolean attr false value' );
   expectToMatch( reAttrsBoolean, '  FOCUSABLE="false"', 'reAttrsBoolean should match allowed boolean attr false value ignore case' );
   expectToMatch( reAttrsBoolean, '  focusable="true"', 'reAttrsBoolean should match allowed boolean attr true value' );
   expectNotToMatch( reAttrsBoolean, `  focusable='true'`, 'reAttrsBoolean should NOT match allowed boolean attr true value single quoted' );
   expectNotToMatch( reAttrsBoolean, `  focusable=true`, 'reAttrsBoolean should NOT match allowed boolean attr true value unquoted' );
   expectNotToMatch( reAttrsBoolean, '  focusable="nope"', 'reAttrsBoolean should NOT match allowed boolean attr non true/false value' );
   expectNotToMatch( reAttrsBoolean, '  focusable=""', 'reAttrsBoolean should NOT match allowed boolean attr empty value' );
   expectNotToMatch( reAttrsBoolean, 'unfocusable="true"', 'reAttrsBoolean should NOT match embedded allowed boolean attr' );
   expectNotToMatch( reAttrsBoolean, '  Width="true"', 'reAttrsBoolean should NOT match non-allowed boolean attr value' );
   expectToMatch( reAttrsBoolean, '  aria-hidden="false"', 'reAttrsBoolean should match allowed aria-hidden value' );
   expectToMatch( reAttrsBoolean, '  aria-modal="false"', 'reAttrsBoolean should match allowed aria-modal value' );
   expectToMatch( reAttrsBoolean, '  aria-invalid="false"', 'reAttrsBoolean should match allowed aria-invalid value' );
   expectToMatch( reAttrsBoolean, '  aria-checked="false"', 'reAttrsBoolean should match allowed aria-checked value' );
   expectToMatch( reAttrsBoolean, '  aria-expanded="false"', 'reAttrsBoolean should match allowed aria-expanded value' );
   expectNotToMatch( reAttrsBoolean, '  aria-other="false"', 'reAttrsBoolean should NON match non-allowed aria-other value' );
   expectNotToMatch( reAttrsBoolean, '  value="false"', 'reAttrsBoolean should NON match non-allowed value value' );
   expectNotToMatch( reAttrsBoolean, '  data-focus-guard="false"', 'reAttrsBoolean should NON match non-allowed data-focus-guard value' );

   expectToMatch( reAttrsToShow, 'id', 'reAttrsToShow should match allowed attr name id', 3 );
   expectToMatch( reAttrsToShow, 'Id', 'reAttrsToShow should match allowed attr name ignore case', 3 );
   expectNotToMatch( reAttrsToShow, 'pid', 'reAttrsToShow should NOT match embedded allowed attr name' );
   expectNotToMatch( reAttrsToShow, '  id  ', 'reAttrsToShow should NOT match spaces around allowed attr name' );
   expectToMatch( reAttrsToShow, 'name', 'reAttrsToShow should match allowed attr named name', 3 );
   expectToMatch( reAttrsToShow, 'type', 'reAttrsToShow should match allowed attr type', 3 );
   expectToMatch( reAttrsToShow, 'role', 'reAttrsToShow should match allowed attr role', 3 );
   expectToMatch( reAttrsToShow, 'target', 'reAttrsToShow should match allowed attr target', 3 );
   expectToMatch( reAttrsToShow, 'rel', 'reAttrsToShow should match allowed attr rel', 3 );
   expectToMatch( reAttrsToShow, 'disabled', 'reAttrsToShow should match allowed attr disabled', 3 );
   expectToMatch( reAttrsToShow, 'focusable', 'reAttrsToShow should match allowed attr focusable', 3 );
   expectToMatch( reAttrsToShow, 'hidden', 'reAttrsToShow should match allowed attr hidden', 3 );
   expectToMatch( reAttrsToShow, 'width', 'reAttrsToShow should match allowed attr width', 3 );
   expectToMatch( reAttrsToShow, 'height', 'reAttrsToShow should match allowed attr height', 3 );
   expectToMatch( reAttrsToShow, 'tabindex', 'reAttrsToShow should match allowed attr tabindex', 3 );
   expectToMatch( reAttrsToShow, 'for', 'reAttrsToShow should match allowed attr for', 3 );
   expectToMatch( reAttrsToShow, 'title', 'reAttrsToShow should match allowed attr title', 3 );
   expectToMatch( reAttrsToShow, 'placeholder', 'reAttrsToShow should match allowed attr placeholder', 3 );
   expectToMatch( reAttrsToShow, 'alt', 'reAttrsToShow should match allowed attr alt', 3 );
   expectToMatch( reAttrsToShow, 'href', 'reAttrsToShow should match allowed attr href', 3 );
   expectToMatch( reAttrsToShow, 'aria-any-thin-at-all', 'reAttrsToShow should match allowed attr aria-any-thin-at-all', 3 );
   expectToMatch( reAttrsToShow, 'data-what-ever', 'reAttrsToShow should match allowed attr data-what-ever', 3 );
   expectNotToMatch( reAttrsToShow, 'class', 'reAttrsToShow should NOT match allowed attr class' );
   expectNotToMatch( reAttrsToShow, 'className', 'reAttrsToShow should NOT match allowed attr className' );
   expectNotToMatch( reAttrsToShow, 'style', 'reAttrsToShow should NOT match allowed attr style' );

   expectToMatch( reRawHtml, '    <p stuff="ha">   ', 'reRawHtml should match HTML whitespaced' );
   expectToMatch( reRawHtml, '    <p stuff="ha">what</p><a>link</a>   ', 'reRawHtml should match multiple HTML whitespaced' );
   expectNotToMatch( reRawHtml, '    p stuff = ha   ', 'reRawHtml should NOT match non-HTML' );
   expectNotToMatch( reRawHtml, '    p stuff = ha   <p stuff="ha">', 'reRawHtml should NOT match non-HTML then HTML' );

   expectToMatch( reDocTextEmpty, '<p stuff="ha">', 'reDocTextEmpty should match element open' );
   expectToMatch( reDocTextEmpty, '</p>', 'reDocTextEmpty should match element close' );
   expectToMatch( reDocTextEmpty, '<p stuff="ha">HEY</P>', 'reDocTextEmpty should match multiple elements', 2 );
   expectNotToMatch( reDocTextEmpty, 'HEY', 'reDocTextEmpty should NOT match non-element text' );

   expectToMatch( reElemWithId, 'some<p x="2" id="34">text</p>', 'reElemWithId should match HTML element with an id' );
   expectToMatch( reElemWithId, 'some<p x="2" iD="34">text</p><a id="55">', 'reElemWithId should match two HTML elements with id', 2 );
   expectNotToMatch( reElemWithId, 'some<p x="2" sid="34">text</p>', 'reElemWithId should NOT match HTML element with no id' );
   expectNotToMatch( reElemWithId, `some<p x="2" id='34'>text</p>`, 'reElemWithId should NOT match HTML element with a single quoted id' );
   expectToMatch( reElemWithId, `some<p x="2" id="">text</p>`, 'reElemWithId should match HTML element with an empty id' );
   expectNotToMatch( reElemWithId, 'some<p x="2" id=34>text</p>', 'reElemWithId should NOT match HTML element with an unquoted id' );

   expectToMatch( reBoolean, 'false', 'reBoolean should match false' );
   expectToMatch( reBoolean, 'FALSE', 'reBoolean should match FALSE' );
   expectToMatch( reBoolean, 'falsefalse', 'reBoolean should match false twice', 2 );
   expectToMatch( reBoolean, 'unfalseifiable', 'reBoolean should match embedded false' );
   expectToMatch( reBoolean, 'true', 'reBoolean should match true' );
   expectToMatch( reBoolean, 'untruethful', 'reBoolean should match embedded true' );

   expectToMatch( reMissingMoney, `${LS};`, 'reMissingMoney should match missing pounds' );
   expectToMatch( reMissingMoney, 'price $not', 'reMissingMoney should match missing dollars' );
   expectToMatch( reMissingMoney, 'price $not$not', 'reMissingMoney should match missing dollars twice', 2 );
   expectNotToMatch( reMissingMoney, 'price $', 'reMissingMoney should NOT match dollars sign alone' );
   expectNotToMatch( reMissingMoney, 'price $ ', 'reMissingMoney should NOT match dollars space' );
   expectNotToMatch( reMissingMoney, 'price $42.32', 'reMissingMoney should NOT match dollar amount' );

   expectToMatch( reStringified, 'this is undefined text', 'reStringified should match literal undefined' );
   expectToMatch( reStringified, 'this is undefinedundefined text', 'reStringified should match literal undefined twice', 2 );
   expectToMatch( reStringified, 'this is UNDEFINED text', 'reStringified should match literal UNDEFINED' );
   expectToMatch( reStringified, 'this isundefinedtext', 'reStringified should match embedded isundefinedtext' );
   expectToMatch( reStringified, 'this is null text', 'reStringified should match literal null' );
   expectToMatch( reStringified, 'this isnulltext', 'reStringified should match embedded null' );
   expectToMatch( reStringified, 'this is NaN text', 'reStringified should match literal NaN' );
   expectNotToMatch( reStringified, 'this is BaNaNa text', 'reStringified should NOT match BANANA' );
   expectToMatch( reStringified, 'this is Infinity text', 'reStringified should match literal Infinity' );
   expectToMatch( reStringified, 'this isInfinitytext', 'reStringified should match embedded Infinity' );
   expectToMatch( reStringified, 'this is [object Object] text', 'reStringified should match stringified object' );
   expectToMatch( reStringified, 'this is[object Object]text', 'reStringified should match embedded stringified object' );
   expectToMatch( reStringified, 'this is function text', 'reStringified should match stringified function' );
   expectToMatch( reStringified, 'this isfunction text', 'reStringified should match embedded stringified function' );

   expectToMatch( reIndexUp, '[10]', 'reIndexUp should match indexing', 4 );
   expectToMatch( reIndexUp, '  [0]   ', 'reIndexUp should match indexing with spacing', 4 );
   expectToMatch( reIndexUp, '  [-12]   ', 'reIndexUp should match negative index', 4 );
   expectToMatch( reIndexUp, '   ', 'reIndexUp should match empty', 4 );
   expectToMatch( reIndexUp, '^^^', 'reIndexUp should match up the tree', 4 );
   expectToMatch( reIndexUp, ' ^^^  ', 'reIndexUp should match up the tree with spacing', 4 );
   expectToMatch( reIndexUp, '@LIST', 'reIndexUp should match list marker', 4 );
   expectToMatch( reIndexUp, '[5]^^@LIST', 'reIndexUp should match all syntax', 4 );
   expectToMatch( reIndexUp, '  [5] ^^ @LIST ', 'reIndexUp should match all syntax with spacing', 4 );

   const expectMatches: any = [
	  "   [5] @LIST ",
	  "5",
	  "",
	  "@LIST"
   ];
   expectMatches.index = 3;
   expectMatches.input = ' ^^   [5] @LIST ';
   expectToMatch( reIndexUp, ' ^^   [5] @LIST ', 'reIndexUp should parially match all syntax in wrong order', expectMatches.length, expectMatches );

   expectToMatch( reExtraSpacesClosureElem, 'blah />', 'reExtraSpacesClosureElem should match single space on closure of element' );
   expectToMatch( reExtraSpacesClosureElem, 'blah   />', 'reExtraSpacesClosureElem should match excess space on closure of element' );
   expectNotToMatch( reExtraSpacesClosureElem, 'blah/>', 'reExtraSpacesClosureElem should NOT match no spaces on closure of element' );
   expectNotToMatch( reExtraSpacesClosureElem, 'blah >', 'reExtraSpacesClosureElem should NOT match single space on end of element' );

   expectToMatch( reOuterSpaces, '', 'reOuterSpaces should match empty string' );
   expectToMatch( reOuterSpaces, '    ', 'reOuterSpaces should match spaces only' );
   expectToMatch( reOuterSpaces, '    blah blah   ', 'reOuterSpaces should match spaces around text' );
   expectToMatch( reOuterSpaces, 'blah blah', 'reOuterSpaces should match text without spacing' );
   expectToReplace( reOuterSpaces, '    blah blah   \n  blah   blah\n   blah blah\n\n', '@\n@\n@@', 'reOuterSpaces should replace spaces around text with multiple lines', '@' );
   expectToReplace( reOuterSpaces, '    blah blah   ', '1:[    ] 2:[blah blah] 3:[   ]', 'reOuterSpaces should match and replace groups' );

   expectToSplit( /,/, ',a,e,i,o,u', [ '', 'a', 'e', 'i', 'o', 'u' ], 'should split correctly' );
   expectToMatch( reSplitAfterElement, '<p>', 'reSplitAfterElement should match element at end of string' );
   expectToMatch( reSplitAfterElement, '<p>more stuff', 'reSplitAfterElement should match element and stuff at end of string' );
   expectNotToMatch( reSplitAfterElement, '<p>more stuff<', 'reSplitAfterElement should NOT match element with < at end of string' );
   expectNotToMatch( reSplitAfterElement, '<p>more stuff<p', 'reSplitAfterElement should NOT match element with < before end of string' );
   expectToMatch( reSplitAfterElement, '<p>more stuff<p>', 'reSplitAfterElement should match element with <p> at end of string' );
   expectNotToMatch( reSplitAfterElement, '', 'reSplitAfterElement should NOT match empty string' );
   expectToReplace( reSplitAfterElement, '<p>more stuff', '<p1:[more stuff] 2:[$2] 3:[$3]', 'reSplitAfterElement should replace groups' );
   expectToReplace( reSplitAfterElement, '<p>more stuff<p>', '<p>more stuff<p1:[] 2:[$2] 3:[$3]', 'reSplitAfterElement should replace groups' );

   expectToMatch( reSplitBeforeElement, '<p>', 'reSplitBeforeElement should match element at start of string' );
   expectToMatch( reSplitBeforeElement, 'bunch of text<p>', 'reSplitBeforeElement should match stuff before element at start of string' );
   expectToMatch( reSplitBeforeElement, '<p>bunch of text</p>', 'reSplitBeforeElement should match stuff before element at start of string' );
   expectToMatch( reSplitBeforeElement, 'more<p>bunch of text</p>', 'reSplitBeforeElement should match double stuff before element at start of string' );
   expectNotToMatch( reSplitBeforeElement, '', 'reSplitBeforeElement should NOT match empty string' );
   expectToReplace( reSplitBeforeElement, 'bunch of text</p>', '1:[bunch of text] 2:[$2] 3:[$3]/p>', 'reSplitBeforeElement should replace groups' );
   expectToReplace( reSplitBeforeElement, 'more<p>bunch of text</p>', '1:[more] 2:[$2] 3:[$3]p>bunch of text</p>', 'reSplitBeforeElement should replace groups' );

   expectToMatch( reSplitBetweenElement, '<p>what</p><a>the</a>', 'reSplitBetweenElement should match element boundaries', 3, );
   expectToReplace( reSplitBetweenElement, '<p>what</p><a>the</a>', '<p1:[what] 2:[$2] 3:[$3]/p1:[] 2:[$2] 3:[$3]a1:[the] 2:[$2] 3:[$3]/a>', 'reSplitBetweenElement should replace groups' );
   expectNotToMatch( reSplitBetweenElement, '<p what=the/>', 'reSplitBetweenElement should NOT match single element' );

   expectToMatch( reIndentElemAttr, 'width="42"', 'reIndentElemAttr should match an attribute' );
   expectToMatch( reIndentElemAttr, 'aria-WIDTH="42"', 'reIndentElemAttr should match a hyphenated attribute' );
   expectToMatch( reIndentElemAttr, '       width=""    ', 'reIndentElemAttr should match an empty attribute with leading space' );
   expectToMatch( reIndentElemAttr, 'width="42"  height="12"', 'reIndentElemAttr should match multiple attributes', 2 );
   expectToReplace( reIndentElemAttr, 'width="42"  height="12"', '1:[] 2:[width="42"] 3:[$3]1:[] 2:[height="12"] 3:[$3]', 'reIndentElemAttr should replace multiple attributes' );
   expectNotToMatch( reIndentElemAttr, `width='42'`, 'reIndentElemAttr should NOT match a single quoted attribute' );
   expectNotToMatch( reIndentElemAttr, `width=42`, 'reIndentElemAttr should NOT match an unquoted attribute' );

   expectToMatch( reStyleAttr, 'style="blah: blah;"', 'reStyleAttr should match style attribute value' );
   expectToMatch( reStyleAttr, '   style="blah: blah;"   ', 'reStyleAttr should match style attribute value with spacing' );
   expectToMatch( reStyleAttr, '<p   style="blah: blah;"  > <a style="what: what;">', 'reStyleAttr should match multiple style attribute values with spacing', 2 );
   expectNotToMatch( reStyleAttr, 'style=""', 'reStyleAttr should NOT match empty style attribute value' );
   expectNotToMatch( reStyleAttr, "style='blah: blah;'", 'reStyleAttr should NOT match single quoted style attribute value' );
   expectNotToMatch( reStyleAttr, "mystyle='blah: blah;'", 'reStyleAttr should NOT match single quoted embedded style attribute value' );

   expectToMatch( reEndingSemi, ';', 'reEndingSemi should match semicolon only' );
   expectToMatch( reEndingSemi, 'blah;', 'reEndingSemi should match semicolon at end of string' );
   expectNotToMatch( reEndingSemi, ':', 'reEndingSemi should NOT match colon only' );
   expectNotToMatch( reEndingSemi, '  ;  ', 'reEndingSemi should NOT match semicolon with spaces' );
   expectNotToMatch( reEndingSemi, 'blah; end', 'reEndingSemi should NOT match semicolon at middle of string' );
   expectNotToMatch( reEndingSemi, ';blah', 'reEndingSemi should match semicolon at start of string' );

   expectToMatch( reSemiSpaces, ';', 'reSemiSpaces should match semicolon only' );
   expectToMatch( reSemiSpaces, 'blah;', 'reSemiSpaces should match semicolon at end of string' );
   expectToMatch( reSemiSpaces, '  ;  ', 'reSemiSpaces should match semicolon with spaces' );
   expectToMatch( reSemiSpaces, 'blah; end', 'reSemiSpaces should match semicolon at middle of string' );
   expectToMatch( reSemiSpaces, ';blah', 'reSemiSpaces should NOT match semicolon at start of string' );
   expectNotToMatch( reSemiSpaces, ':', 'reSemiSpaces should NOT match colon only' );

   expectToMatch( reLineBeforeElement, '<p>', 'reLineBeforeElement should match start of string before element' );
   expectToMatch( reLineBeforeElement, '\n<p>', 'reLineBeforeElement should match newline before element' );
   expectToMatch( reLineBeforeElement, 'blah blah\n<p>', 'reLineBeforeElement should match extra stuff then newline before element' );
   expectNotToMatch( reLineBeforeElement, '  <p>', 'reLineBeforeElement should NOT match space before element' );
   expectNotToMatch( reLineBeforeElement, 'blah blah<p>', 'reLineBeforeElement should NOT match extra stuff before element' );

   expectToMatch( reLineBeforeText, 'blah</p>', 'reLineBeforeText should match end of line' );
   expectToMatch( reLineBeforeText, 'blah</p>\n', 'reLineBeforeText should match new line' );
   expectToMatch( reLineBeforeText, '<h1>head</h1>   <b>bold</b>\n\n<p>blah</p>\n<i>italic</i>', 'reLineBeforeText should match multiple', 3 );
   expectNotToMatch( reLineBeforeText, 'blah</p>  \n', 'reLineBeforeText should NOT match spaces' );

   expectToMatch( reAttribute, 'width="42"', 'reAttribute should match an attribute' );
   expectToMatch( reAttribute, 'aria-WIDTH="42"', 'reAttribute should match a hyphenated attribute' );
   expectToMatch( reAttribute, '       width=""    ', 'reAttribute should match an empty attribute with leading space' );
   expectToMatch( reAttribute, 'width="42"  height="12"', 'reAttribute should match multiple attributes', 2 );
   expectToReplace( reAttribute, 'width="42"  height="12"', '1:[width] 2:["42"] 3:[$3]1:[height] 2:["12"] 3:[$3]', 'reAttribute should replace multiple attributes' );
   expectNotToMatch( reAttribute, `width='42'`, 'reAttribute should NOT match a single quoted attribute' );
   expectNotToMatch( reAttribute, `width=42`, 'reAttribute should NOT match an unquoted attribute' );

   expectToMatch( reExtraSpacesElem, 'blah >', 'reExtraSpacesElem should match single space on end of element' );
   expectToMatch( reExtraSpacesElem, 'blah   >', 'reExtraSpacesElem should match excess space on end of element' );
   expectNotToMatch( reExtraSpacesElem, 'blah>', 'reExtraSpacesElem should NOT match no spaces on end of element' );
   expectNotToMatch( reExtraSpacesElem, 'blah />', 'reExtraSpacesElem should NOT match single space on closure of element' );

   expectToMatch( rePlainElem, '<span>', 'rePlainElem should match opening element' );
   expectToMatch( rePlainElem, '</spAN>', 'rePlainElem should match closing element' );
   expectToMatch( rePlainElem, 'text<span> embedded', 'rePlainElem should match embedded opening element' );
   expectToMatch( rePlainElem, '<span>text</span> <em>embedded</em>', 'rePlainElem should match multiple elements', 4 );
   expectNotToMatch( rePlainElem, '<span >', 'rePlainElem should NOT match opening element with internal spaces' );
   expectNotToMatch( rePlainElem, '<span id=32>', 'rePlainElem should NOT match opening element with attributes' );

   expectToMatch( reBlankLines, '\n\n', 'reBlankLines should match two newlines' );
   expectToMatch( reBlankLines, 'what\n\n   ', 'reBlankLines should match embedded newlines' );
   expectToMatch( reBlankLines, '\n  \t \n', 'reBlankLines should match two newlines and spaces between' );
   expectToMatch( reBlankLines, '\n\n\n\n\n', 'reBlankLines should match multiple newlines' );
   expectNotToMatch( reBlankLines, '\n', 'reBlankLines should NOT match single newline' );
   expectToMatch( reBlankLines, 'this\n  \ndouble\n  \n  \n  spaced', 'reBlankLines should match multiple newlines and text breaks', 2 );
   expectToReplace( reBlankLines, '\n \n \t \n\n\n\n', 'BRK', 'reBlankLines should replace multiple newlines', 'BRK' );

   expectToMatch( reAttrIdentity, 'xx  id="false"', 'reAttrIdentity should match id attribute' );
   expectToMatch( reAttrIdentity, 'name="Fred"', 'reAttrIdentity should match name attribute' );
   expectToMatch( reAttrIdentity, 'role="Fred"', 'reAttrIdentity should match role attribute' );
   expectToMatch( reAttrIdentity, 'data-anything="Fred"', 'reAttrIdentity should match data-* attribute' );
   expectToMatch( reAttrIdentity, 'aria-label="Fred"', 'reAttrIdentity should match aria-label attribute' );
   expectToMatch( reAttrIdentity, 'aria-labelledby="Fred"', 'reAttrIdentity should match aria-label* attribute' );
   expectToMatch( reAttrIdentity, 'aria-desc="Fred"', 'reAttrIdentity should match aria-desc attribute' );
   expectToMatch( reAttrIdentity, 'aria-description="Fred"', 'reAttrIdentity should match aria-desc attribute' );
   expectToMatch( reAttrIdentity, 'aria-desctibedby="Fred"', 'reAttrIdentity should match aria-desc* attribute' );
   expectToMatch( reAttrIdentity, 'aria-role="Fred"', 'reAttrIdentity should match aria-role attribute' );
   expectToMatch( reAttrIdentity, 'aria-roledescription="Fred"', 'reAttrIdentity should match aria-role* attribute' );
   expectNotToMatch( reAttrIdentity, 'ploughname="Fred"', 'reAttrIdentity should NOT match embedded name attribute' );
   expectToMatch( reAttrIdentity, 'name="Fred" id="1234" role="checkbox"', 'reAttrIdentity should match multiple attributes', 3 );
   expectToMatch( reAttrIdentity, 'width="42" name="Fred" id="1234" yes="23" role="checkbox"', 'reAttrIdentity should match multiple identity attributes only', 3 );
   expectNotToMatch( reAttrIdentity, 'width="Fred"', 'reAttrIdentity should NOT match non-identity attribute' );
   expectNotToMatch( reAttrIdentity, 'namE="fred"', 'reAttrIdentity should NOT match upper case' );
   expectNotToMatch( reAttrIdentity, 'name=""', 'reAttrIdentity should NOT match empty name attribute' );
   expectNotToMatch( reAttrIdentity, 'aria-anything="Fred"', 'reAttrIdentity should NOT match aria-* attribute' );

   expectToMatch( reElemNoAttr, '<span>', 'reElemNoAttr should match opening element' );
   expectToMatch( reElemNoAttr, '</spAN>', 'reElemNoAttr should match closing element' );
   expectToMatch( reElemNoAttr, 'text<span> embedded', 'reElemNoAttr should match embedded opening element' );
   expectToMatch( reElemNoAttr, '<span>text</span> <em>embedded</em>', 'reElemNoAttr should match multiple elements', 4 );
   expectToMatch( reElemNoAttr, '<span   >', 'reElemNoAttr should match opening element with internal spaces' );
   expectNotToMatch( reElemNoAttr, '<span id="32">', 'reElemNoAttr should NOT match opening element with attributes' );

   expectToMatch( reMultiSpaced, '\n\n', 'reMultiSpaced should match two newlines' );
   expectToMatch( reMultiSpaced, 'what\n\n   ', 'reMultiSpaced should match embedded newlines' );
   expectToMatch( reMultiSpaced, '\n  \t \n', 'reMultiSpaced should match two newlines and spaces between' );
   expectToMatch( reMultiSpaced, '\n\n\n\n\n', 'reMultiSpaced should match multiple newlines' );
   expectNotToMatch( reMultiSpaced, '\n', 'reMultiSpaced should NOT match single newline' );
   expectToMatch( reMultiSpaced, 'this\n  \ndouble\n  \n  \n  spaced', 'reMultiSpaced should match multiple newlines and text breaks', 2 );
   expectToReplace( reMultiSpaced, '\n \n \t \n\n\n\n', 'BRK', 'reMultiSpaced should replace multiple newlines', 'BRK' );

   expectToMatch( reNicePreamble, '\n========== S\n', 'reNicePreamble should match minimally at new line' );
   expectToMatch( reNicePreamble, '\n\n\n========== blah blah\n', 'reNicePreamble should match at new line' );
   expectToMatch( reNicePreamble, 'blah blah\n\n========== blah blah\n', 'reNicePreamble should match within text' );
   expectToMatch( reNicePreamble, '\n============== S\n', 'reNicePreamble should match more equal signs' );
   expectNotToMatch( reNicePreamble, '========== \n', 'reNicePreamble should NOT match if no newline' );
   expectNotToMatch( reNicePreamble, '\n========= S\n', 'reNicePreamble should NOT match too few equal signs' );
   expectToMatch( reNicePreamble, '\n============== HTML\nblah blah blah\n========== HEY\n', 'reNicePreamble should greedy match multiple banners' );

   expectToMatch( reInitialLineSpaces, '  \t  what', 'reInitialLineSpaces should match with initial line spaces' );
   expectToMatch( reInitialLineSpaces, '\n  \t  what', 'reInitialLineSpaces should match with newline and line spaces' );
   expectToMatch( reInitialLineSpaces, 'what', 'reInitialLineSpaces should match with no initial line spaces' );

   expectToMatch( reNewLines, '\n', 'reNewLines should match single newline' );
   expectToMatch( reNewLines, '\n\n', 'reNewLines should match two newlines', 2 );
   expectToMatch( reNewLines, 'what\n\n   ', 'reNewLines should match embedded newlines', 2 );
   expectToMatch( reNewLines, '\n  \t \n', 'reNewLines should match two newlines and spaces between', 2 );
   expectToMatch( reNewLines, '\n\n\n\n\n', 'reNewLines should match multiple newlines', 5 );
   expectToMatch( reNewLines, 'this\n  \ndouble\n  \n  \n  spaced', 'reNewLines should match multiple newlines and text breaks', 5 );
   expectToReplace( reNewLines, '\n \n \t \n\n\n\n', 'BRK BRK \t BRKBRKBRKBRK', 'reNewLines should replace multiple newlines', 'BRK' );
   expectNotToMatch( reNewLines, 'what   ', 'reNewLines should NOT match no newlines' );

   expectToMatch( reExpectStraggler, '\n\n  expect(screen.queryByText(RE[   ', 'reExpectStraggler should match expect test leftovers' );
   expectToMatch( reExpectStraggler, 'blah blah\n\n  expect(screen.queryByText(RE[   ', 'reExpectStraggler should match expect test leftovers multiline' );
   expectNotToMatch( reExpectStraggler, '\n\n  expect(screen.getByText(RE[   ', 'reExpectStraggler should NOT match expect test leftovers' );
   expectToReplace( reExpectStraggler, 'blah blah\n\n  expect(screen.queryByText(RE[   ', 'blah blah\n1:[$1] 2:[$2] 3:[$3]', 'reExpectStraggler should replace expect test leftovers multiline' );

   expectToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER', 'reEmbeddedRE should match a quoted regular expression' );
   expectToMatch( reEmbeddedRE, 'RE[/RE\[(.+?)\]ER/g]ER', 'reEmbeddedRE should match a quoted regular expression of similar structure' );
   expectToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER    RE[/RE\\[(.+?)\\]ER/g]ER', 'reEmbeddedRE should match multiple quoted regular expression', 2 );
   expectNotToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]', 'reEmbeddedRE should NOT match an incomplete quoted regular expression' );
   expectToReplace( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER    RE[/RE\\[(.+?)\\]\\ER/g]ER', '1:[/>([^<]*)$/g] 2:[$2] 3:[$3]    1:[/RE\\[(.+?)\\]\\ER/g] 2:[$2] 3:[$3]', 'reEmbeddedRE should replace quoted regular expression' );

   expectToMatch( reSpaceMarker, '[SPACE]', 'reSpaceMarker should match a space character marker' );
   expectToMatch( reSpaceMarker, '[SPACE][SPACE][SPACE]', 'reSpaceMarker should match multiple space character markers' );
   expectToMatch( reSpaceMarker, '[SPACE]\t[SPACE]\t[SPACE]', 'reSpaceMarker should match multiple space character markers', 3 );
   expectNotToMatch( reSpaceMarker, '[space]', 'reSpaceMarker should NOT match a space character marker lower case' );

   expectToMatch( reRemoveBlankExpects, '    expect(screen.queryByText(BLANKBLANK)).toBeInTheDocument();\n', 'reRemoveBlankExpects should match expect ... BLANKBLANK' );

   //==========================================================
   // tests to validate it's working...

   expectToBe( NaN, NaN, `should pass for NaN comparison` );
   expectToBe( Infinity, Infinity, `should pass for Infinity comparison` );
   if ( LET_FAIL_TESTS )
   {
	  expectNotToBe( NaN, NaN, `should fail for NaN comparison` );
   }

   EX_SHOW_SPACES = true;
   expectToBe( show(
	  ' \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u0020\v\w\x0a\y\z ' ),
	  '~a\bcde\\fghijklm\\nopq\\rs\\t~\\vw\\nyz~', 'show() should requote white space characters' );
   expectToBe( show(
	  '  \x0d \f \n \r \t \u0020 \x0d\x0a \v \x0a  ' ),
	  '~~\\r~\\f~\\n~\\r~\\t~~~\\r\\n~\\v~\\n~~', 'show() should requote white space characters handling newlines' );
   EX_SHOW_SPACES = false;

   expectToBe( replaceSpaces(
	  '\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u0020\v\w\x0a\y\z' ),
	  'a\bcdeghijklm\nopqsw\x0ayz', 'replaceSpaces() should remove white space characters' );
   expectToBe( replaceSpaces(
	  '  \x0d \f \n \r \t \u0020 \x0d\x0a \v \x0a  ' ),
	  '\n\x0a\x0a', 'replaceSpaces() should remove white space characters except newlines' );

   expectToBe( showSpaces( ' initial  medial final  \n\n' ), '[SPACE]initial  medial final[SPACE][SPACE]\n\n', 'showSpaces() should make white spaces visible' )
   expectToBe( showSpaces( '   initial   internal  final  spaces     ', '@' ), '@@@initial   internal  final  spaces@@@@@', 'showSpaces() should make white spaces visible with @ sign' )
   expectToBe( showSpaces( ' initial\n  med\t ial\  \nfinal\  \n\n', '@' ), '@initial\n@@med\t ial@@\nfinal@@\n\n', 'showSpaces() should work across multiple lines of text' )

   expectToBe( dskipIfJenkins, describe.skip, 'should have describe skip function activated for jenkins' );
   expectToBe( skipIfJenkins, test.skip, 'should have skip function activated for jenkins' );

   if ( NOISY )
   {
	  trace( `this is my trace message`, [ 42, 12 ] );
	  trace( `this is another trace function`, { list: [ 42, 12 ] } );
   }

   win.document = mockDocument( '<main><span>version.nickname: JIRA-NNNN XYZY</span><h1>heading</h1><hr/><p id="mypara">this is the text</p><hr /></main>' );

   const window = win;
   mockWindowLocation( void 0, window );
   // trace(`window`, window);
   expectToBe( window.location.href, 'htt\p://localhost.site:3000/#/', 'should set window href' );
   expectToBe( window.location.origin, 'htt\p://localhost.site:3000', 'should set window origin' );
   expectToBe( window.location.protocol, 'htt\p:', 'should set window protocol' );
   expectToBe( window.location.username, '', 'should set window username' );
   expectToBe( window.location.password, '', 'should set window password' );
   expectToBe( window.location.host, 'localhost.site:3000', 'should set window host' );
   expectToBe( window.location.hostname, 'localhost.site', 'should set window hostname' );
   expectToBe( window.location.port, '3000', 'should set window port' );
   expectToBe( window.location.pathname, '/', 'should set window pathname' );
   expectToBe( window.location.search, '', 'should set window search' );
   expectToBe( window.location.hash, '#/', 'should set window hash' );
   expectToEqual( window.location.searchParams, {}, 'should set window search' );
   window.location.assign( 'ft\p://john:doe@go.com:3333/path/name?param=34&that=this#hashpath' );
   // trace(`window.location`, window.location);
   expectToBe( window.location.href, 'ft\p://john:doe@go.com:3333/path/name?param=34&that=this#hashpath', 'should set window href as ftp' );
   expectToBe( window.location.origin, 'ft\p://go.com:3333', 'should set window origin' );
   expectToBe( window.location.protocol, 'ft\p:', 'should set window protocol' );
   expectToBe( window.location.username, 'john', 'should set window username' );
   expectToBe( window.location.password, 'doe', 'should set window password' );
   expectToBe( window.location.host, 'go.com:3333', 'should set window host' );
   expectToBe( window.location.hostname, 'go.com', 'should set window hostname' );
   expectToBe( window.location.port, '3333', 'should set window port' );
   expectToBe( window.location.pathname, '/path/name', 'should set window pathname' );
   expectToBe( window.location.search, '?param=34&that=this', 'should set window search' );
   expectToBe( window.location.hash, '#hashpath', 'should set window hash' );
   expectToEqual( window.location.searchParams, {}, 'should set window search' );
   window.location.replace( 'fil\e:/path' );
   window.location.reload();
   expectToBe( window.location.href, 'fil\e:///path', 'should set window href as a file' );
   expectToBe( window.location.origin, 'null', 'should set window origin' );
   expectToBe( window.location.protocol, 'file:', 'should set window protocol' );
   expectToBe( window.location.pathname, '/path', 'should set window pathname' );
   //  trace(`window.location`, window.location);

   var document = mockDocument( '<main><span>version.nickname: JIRA-NNNN XYZY</span><hr/><p id="mypara" uuid="uuid" parole="parole" title="tooltip text">  </p><hr /></main>' );
   EX_SHOW_SPACES = true;
   checkDocumentTextEmpty();
   if ( LET_FAIL_TESTS )
   {
	  checkDocumentTextEmpty( win.document.body );
   }
   EX_SHOW_SPACES = false;

   expectToBe( elementAt(), 'ELEMENT', 'elementAt() should return current value' );
   expectToBe( elementAt( 'NEWVALUE' ), 'ELEMENT', 'elementAt() should not have changed' );
   expectToBe( elementAt(), 'NEWVALUE', 'elementAt() should return changed value' );

   expectToBe( getElementById( 'missingId' ), null, 'getElementById() should return null' );

   document.getElementById = () => 'FOUND' as unknown as HTMLElement;
   expectToBe( getElementById( 'myid' ), 'FOUND', 'getElementById() should return an element using document.getElementById' );

   document.getElementById = null;
   document.querySelector = () => 'FOUNDED' as unknown as HTMLElement;
   expectToBe( getElementById( 'myid' ), 'FOUNDED', 'getElementById() should return an element using document.querySelector' );
   document.querySelector = null;

   let looped = '';
   forOf<string[], string>( [ 'the', 'brown', 'fox' ], ( item: string, index: number ) =>
   {
	  looped += `${index}:${item} `;
   } );
   expectToBe( looped, '0:the 1:brown 2:fox ', 'forOf() should loop through an array' );

   looped = '';
   forOf( { the: 'bloody', fox: 'died' }, ( item: string, index: number ) =>
   {
	  looped += `${index}:${item} `;
   } );
   // cannot loop through an object with for of in this version...
   if ( LET_FAIL_TESTS )
   {
	  expectToBe( looped, '0:the 1:bloody 2:fox 3:died ', 'forOf() should iterate through an iterable' );
   }

   const el = {
	  tagName: 'main',
	  attributes: [ {
		 name: 'id',
		 value: 'ID',
	  }, {
		 name: 'width',
		 value: 32,
	  }]
   } as unknown as IElement;
   expectToBe( elementInfo( el ), '<main id="ID" width="32" />', 'should show element and attributes' );
   el.outerHTML = elementInfo( el );
   el.innerHTML = '';

   document.getElementById = () => null;
   document.querySelector = () => null;
   document.querySelectorAll = () => [] as any;
   document.getElementsByClassName = () => [] as any;

   elementAt( 'NIL' );
   expectToEqual( getEl( '<h1>HEADING</h1>' ), { innerHTML: '<h1>HEADING</h1>' }, 'getEl(raw html) should return the html as .innerHTML' );
   expectToBe( elementAt(), 'GET EL RAW HTML STRING', 'elementAt() should be set to raw html message' );
   expectToBe( getEl( el ), el, 'getEl(element) should return the element itself' );
   expectToBe( elementAt(), 'GET EL ELEMENT <main id="ID" width="32" />', 'elementAt() should be set to ELEMENT dump ' );
   expectToBe( getEl(), document.body, 'getEl() should return the document.body' );
   expectToBe( elementAt(), 'GET EL ELEMENT <body />', 'elementAt() should return element body message' );

   const div = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'id',
		 value: 'ID',
	  }, {
		 name: 'width',
		 value: 32,
	  }]
   } as unknown as IElement;
   const span = {
	  tagName: 'span',
	  attributes: [ {
		 name: 'id',
		 value: 'SPN',
	  }, {
		 name: 'width',
		 value: 12,
	  }],
	  parentElement: div,
   } as unknown as IElement;

   document.querySelectorAll = () => [ div, div, span ] as any;
   // trace(`document`, document);
   expectToBe( getEl( 2 ), span, 'getEl(2) should return the 3rd div/span in the document' );
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [2] go up 0\nlookup @[2] of 3 matched ==> [[ByQuerySelector#2 <span id="SPN" width="12" />]]', 'elementAt() should return find message' );
   expectToBe( getEl( 'div,span [1]' ), div, 'getEl(div,span [1]) should return the 2nd div/span in the document' );
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [1] go up 0\nlookup @[1] of 3 matched ==> [[ByQuerySelector#1 <div id="ID" width="32" />]]', 'elementAt() should return find message with index value' );
   expectToBe( getEl( 'div,span [2]^' ), div, 'getEl(div,span [2]^) should return the parent element of the 3rd div/span in the document' );
   expectToBe( getEl( 'div,span', '[-1]^' ), div, 'getEl(div,span, [-1]^) should return the parent element of the last div/span in the document' );
   EX_SHOW_SPACES = true;
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [-1] go up 1\nlookup @[2] of 3 matched ==> [[ByQuerySelector#2 <span id="SPN" width="12" />]]\nup to parent --> <div id="ID" width="32" /> ', 'elementAt() should return find message with negative index and go up 1' );
   EX_SHOW_SPACES = false;
   expectToBe( getEl( 'div,span @LIST' ), div, 'getEl(div,span @LIST) should return first div and log the full list' );

   const openTestId = {
	  tagName: 'span',
	  attributes: [ {
		 name: 'data-testid',
		 value: 'accordion-open',
	  }, {
		 name: 'class',
		 value: 'open',
	  }],
	  innerHTML: 'Open the door',
	  innerText: 'Open the door',
   } as unknown as IElement;
   const openId = {
	  tagName: 'button',
	  attributes: [ {
		 name: 'id',
		 value: 'accordion-open',
	  }],
	  innerHTML: 'Open',
	  innerText: 'Open',
	  parentElement: openTestId,
   } as unknown as IElement;
   const openLabel = {
	  tagName: 'label',
	  attributes: [ {
		 name: 'for',
		 value: 'account-open',
		 title: 'This will allow you to open a current or savings account',
	  }],
	  innerHTML: 'Open an account',
	  innerText: 'Open an account',
   } as unknown as IElement;
   const openAlt = {
	  tagName: 'img',
	  attributes: [ {
		 name: 'alt',
		 value: 'An opening in a wall with flowers growing within it.',
	  }, {
		 name: 'src',
		 value: 'data@13552aCe',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;
   const openPlace = {
	  tagName: 'input',
	  attributes: [ {
		 name: 'name',
		 value: 'opening-balance',
	  }, {
		 name: 'placeholder',
		 value: 'opening balance...',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;
   const openInput = {
	  tagName: 'input',
	  attributes: [ {
		 name: 'name',
		 value: 'transaction-state',
	  }, {
		 name: 'value',
		 value: 'open',
	  }, {
		 name: 'role',
		 value: 'dropdown',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;

   document.querySelectorAll = () => [] as any;
   document.getElementById = () => openId as any;
   document.getElementsByClassName = () => [ openId ] as any;
   screen.queryAllByTestId = () => [ openTestId ];
   screen.queryAllByLabelText = () => [ openLabel ];
   screen.queryAllByText = () => [ openLabel, openId, openTestId ];
   screen.queryAllByTitle = () => [ openLabel ];
   screen.queryAllByAltText = () => [ openAlt ];
   screen.queryAllByPlaceholderText = () => [ openPlace ];
   screen.queryAllByDisplayValue = () => [ openInput ];
   screen.queryAllByRole = () => [];
   expectToBe( getEl( /open/i ), openTestId, 'getEl(/open/i) should return the first match of regex /open/' );
   expectToBe( elementAt(), 'GET EL REGEX ANY MATCH FOR /open/i\nlookup @[0] of 11 matched ==> [[ByTestId#0 <span data-testid="accordion-open" class="open" />]]', 'elementAt() should return by testid message' );
   expectToBe( getEl( /open/i, '[4]^@LIST' ), openTestId, 'getEl(/open/i,[4]^@LIST) should return the fifth match of regex /open/ and go up 1, logging the full list' );
   expectToBe( elementAt(), 'GET EL REGEX ANY MATCH FOR /open/i [4] go up 1\nlookup @[4] of 11 matched ==> [[ByText#1 <button id="accordion-open" />]]\nup to parent --> <span data-testid="accordion-open" class="open" /> ', 'elementAt() should return regex match, index and up message' );

   const stylesheet = `
display: none;
width: 100%;
height: 30vh;
  `.trim().replace( /\n/g, '' );

   const rawHtml = `
<h1>HEADING</h1>
<main>
<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />
<article>  This   is an \narticle\n in the document  </article>
<hr />
<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="${stylesheet}" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">footer</footer>
</main>
  `.trim().replace( />\n/g, '>' );
   const rawHtmlNoNL = rawHtml.replace( /\n/g, '' );
   //console.warn(`rawHtml: `, rawHtml);

   const expectHtmlNoNLOld = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNoNL = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n[SPx2]This[SPx3]is an article in the document[SPx2]\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlSpc = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n\\s\\sThis   is an article in the document\\s\\s\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNiceOld = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img\n	alt="icon plus"\n	src="./icon-plus.svg"\n	width="32"\n	height="32"/>\n\n<article>\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n</article>\n\n<hr />\n\n<footer\n	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	value="false"\n	focusable="true"\n	aria-hidden="false"\n	aria-modal="true"\n	aria-invalid="false"\n	aria-checked="true"\n	aria-expanded="false"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"\n	class="CLASS"\n	styles="\n		display: none;\n		width: 100%;\n		height: 30vh\n	"\n	type="TYPE"\n	target="TARGET"\n	rel="REL"\n	disabled="true"\n	focusable="false"\n	hidden="true"\n	width="WIDTH"\n	height="HEIGHT"\n	tabindex="TABINDEX"\n	for="FOR"\n	title="TITLE"\n	placeholder="PLACEHOLDER"\n	alt="ALT"\n	href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNice = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img\n	alt="icon plus"\n	src="./icon-plus.svg"\n	width="32"\n	height="32"/>\n\n<article>\n[SPx2]This[SPx3]is an article in the document[SPx2]\n</article>\n\n<hr />\n\n<footer\n	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	value="false"\n	focusable="true"\n	aria-hidden="false"\n	aria-modal="true"\n	aria-invalid="false"\n	aria-checked="true"\n	aria-expanded="false"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"\n	class="CLASS"\n	styles="\n		display: none;\n		width: 100%;\n		height: 30vh\n	"\n	type="TYPE"\n	target="TARGET"\n	rel="REL"\n	disabled="true"\n	focusable="false"\n	hidden="true"\n	width="WIDTH"\n	height="HEIGHT"\n	tabindex="TABINDEX"\n	for="FOR"\n	title="TITLE"\n	placeholder="PLACEHOLDER"\n	alt="ALT"\n	href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectTextNiceOld = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		alt="icon plus"\n		width="32"\n		height="32"/>\n\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n\n	<footer \n		id="FOOTER"\n		name="NAME"\n		role="ROLE"\n		data-testid="DATA-TESTID"\n		aria-label="LABEL"\n		aria-description="ADESC"\n		aria-role="AROLE"\n		aria-rolel="AROLEL"\n		focusable="true"\n		aria-hidden="false"\n		aria-modal="true"\n		aria-invalid="false"\n		aria-checked="true"\n		aria-expanded="false"\n		data-focus-guard="true"\n		data-focus-lock-disabled="false"\n		data-autofocus-inside="true"\n		data-popper-arrow="false"\n		data-oranges="true"\n		type="TYPE"\n		target="TARGET"\n		rel="REL"\n		disabled="true"\n		focusable="false"\n		hidden="true"\n		width="WIDTH"\n		height="HEIGHT"\n		tabindex="TABINDEX"\n		for="FOR"\n		title="TITLE"\n		placeholder="PLACEHOLDER"\n		alt="ALT"\n		href="#HREF">\n\nfooter\n\n`;
   const expectTextNice1Old = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		src="./icon-plus.svg"/>\n\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n\n	<footer \n		value="false"\n		class="CLASS"\n		style="display: none;width: 100%;height: 30vh;">\n\nfooter\n\n`;
   const expectTextNice = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		alt="icon plus"\n		width="32"\n		height="32"/>\n\n[SPx2]This[SPx3]is an article in the document[SPx2]\n\n	<footer \n		id="FOOTER"\n		name="NAME"\n		role="ROLE"\n		data-testid="DATA-TESTID"\n		aria-label="LABEL"\n		aria-description="ADESC"\n		aria-role="AROLE"\n		aria-rolel="AROLEL"\n		focusable="true"\n		aria-hidden="false"\n		aria-modal="true"\n		aria-invalid="false"\n		aria-checked="true"\n		aria-expanded="false"\n		data-focus-guard="true"\n		data-focus-lock-disabled="false"\n		data-autofocus-inside="true"\n		data-popper-arrow="false"\n		data-oranges="true"\n		type="TYPE"\n		target="TARGET"\n		rel="REL"\n		disabled="true"\n		focusable="false"\n		hidden="true"\n		width="WIDTH"\n		height="HEIGHT"\n		tabindex="TABINDEX"\n		for="FOR"\n		title="TITLE"\n		placeholder="PLACEHOLDER"\n		alt="ALT"\n		href="#HREF">\n\nfooter\n\n`;
   const expectTextNice1 = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		src="./icon-plus.svg"/>\n\n[SPx2]This[SPx3]is an article in the document[SPx2]\n\n	<footer \n		value="false"\n		class="CLASS"\n		style="display: none;width: 100%;height: 30vh;">\n\nfooter\n\n`;

   EX_AS_JS = true;
   const html = getHtml( rawHtmlNoNL );
   const htmlOld = getHtml( rawHtmlNoNL, SPC );
   expectToBe( rawHtml, rawHtml, 'getHtml(rawHtml) should return HTML with newlines in it as is, does not recognise it as raw HTML' );
   expectToBe( html, expectHtmlNoNL, 'getHtml(rawHtml minus \\n) should return the HTML formatted minimally' );
   expectToBe( htmlOld, expectHtmlNoNLOld, 'getHtml(rawHtml minus \\n, SPC) should return the HTML formatted minimally with [SPACE] markers' );
   expectToBe( getHtml( rawHtmlNoNL, '\\s' ), expectHtmlSpc, 'getHtml(with \\s marker) should return the HTML with \\s as space marker' );
   expectToBe( getHtmlNice( rawHtmlNoNL ), expectHtmlNice, 'getHtmlNice(rawHtml minus \\n) should return the HTML formatted one element per line' );
   expectToBe( getHtmlNice( rawHtmlNoNL, SPC ), expectHtmlNiceOld, 'getHtmlNice(rawHtml minus \\n, SPC) should return the HTML formatted one element per line with [SPACE] markers' );
   expectToBe( getHtmlNice( rawHtmlNoNL, '\\s' ), expectHtmlNiceOld.replace( /\[SPACE\]/g, '\\s' ), 'getHtmlNice(with \\s marker) should return the HTML with \\s as space markers' );

   if ( FLIP )
   {
	  expectToBe( getTextNice( rawHtmlNoNL ), expectTextNice1, 'getTextNice1(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
	  expectToBe( getTextNice( rawHtmlNoNL, SPC ), expectTextNice1Old, 'getTextNice1(rawHtml minus \\n, SPC) should return the Text with only HTML elements showing relevant attributes and [SPACE] markers' );
	  expectToBe( getTextNice( rawHtmlNoNL, '@' ), expectTextNice1Old.replace( /\[SPACE\]/g, '@' ), 'getTextNice1(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
   } else
   {
	  expectToBe( getTextNice( rawHtmlNoNL ), expectTextNice, 'getTextNice2(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
	  expectToBe( getTextNice( rawHtmlNoNL, SPC ), expectTextNiceOld, 'getTextNice2(rawHtml minus \\n, SPC) should return the Text with only HTML elements showing relevant attributes and [SPACE] markers' );
	  expectToBe( getTextNice( rawHtmlNoNL, '@' ), expectTextNiceOld.replace( /\[SPACE\]/g, '@' ), 'getTextNice2(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
   }

   EX_AS_JS = false;
   if ( NOISY )
   {
	  console.warn( `\ngetHtml: `, html );
	  console.warn( `\ngetHtmlNice: `, getHtmlNice( rawHtmlNoNL ) );
	  console.warn( `\ngetTextNice: `, getTextNice( rawHtmlNoNL ) );
   }

   window.document = document;
   //trace(`window`, window);

   expectToEqual( freezeTime(), '2024-07-04T01:02:03.000Z', 'freezeTime() should return the specific date' );

   const jestSpy = jest.fn();
   if ( NOISY )
   {
	  logMock( void 0, logMock );
	  logMock( 'HEREWEARE', jestSpy );
   }

   const quoted = quotemeta( '/^(.+)[a-z]*?(a|b{2,}|\t\x0d\x0a\u2026)$/' );
   expectToBe( quoted, '\\/\\^\\(\\.\\+\\)\\[a-z\\]\\*\\?\\(a\\|b\\{2,\\}\\|\t\x0d\x0a\u2026\\)\\$\\/', 'quotemeta() should escape regex meta characters in the string' );
   expectToMatch( new RegExp( quoted ), '/^(.+)[a-z]*?(a|b{2,}|\t\x0d\x0a\u2026)$/', 'quoted regex should match content' );

   if ( LET_FAIL_TESTS )
   {
	  checkPageIds();
   }
   checkPageIds( document.body.innerHTML.replace( 'mypara', `${appId}-mypara` ) );

   checkUndefined( '$14.00' );
   checkUndefined( `${LS}14.00` );
   checkUndefined( '<a focusable="false">' );
   checkUndefined( 'BaNaNa' );
   if ( LET_FAIL_TESTS )
   {
	  checkUndefined( '$NaN' );
	  checkUndefined( `${LS}NaN` );
	  checkUndefined( 'focusable="false" value="true"' );
	  checkUndefined( 'undefined' );
	  checkUndefined( 'null' );
	  checkUndefined( 'NaN' );
	  checkUndefined( 'Infinity' );
	  checkUndefined( {}.toString() );
	  checkUndefined( noop.toString() );
   }

   window.getComputedStyle = () => { return { visibility: 'visible' } };
   const dialogElOpen = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'role',
		 value: 'dialog',
	  }, {
		 name: 'aria-modal',
		 value: 'true',
	  }, {
		 name: 'aria-hidden',
		 value: 'false',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as HTMLElement;
   const dialogElClosed = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'hidden',
		 value: '',
	  }, {
		 name: 'role',
		 value: 'dialog',
	  }, {
		 name: 'aria-modal',
		 value: 'true',
	  }, {
		 name: 'aria-hidden',
		 value: 'true',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as HTMLElement;

   checkDialogClosed( dialogElClosed );
   checkDialogOpen( dialogElOpen );
   if ( LET_FAIL_TESTS )
   {
	  checkDialogOpen( dialogElClosed );
	  checkDialogClosed( dialogElOpen );
   }

   const expectIdentity = `	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"`;

   expectToBe( getIdentity(), '\tid="mypara"', 'getIdentity() should show all relevant identity attributes in the document' );
   expectToBe( getIdentity( html ), expectIdentity, 'getIdentity() should show all relevant identity attributes in the document' );

   const expectExpectations = `\n    \n    // render() your component...\n    console.warn('IDENTITY', getIdentity());\n    const before = getHtmlNice();\n    console.warn('RENDER', before);\n    expect(checkUndefined()).toBeTruthy();\n    expect(checkPageIds()).toBeTruthy();\n    expect(checkDocumentTextEmpty()).toBeTruthy();\n    expect(checkDialogOpen(dialog)).toBeTruthy();\n    expect(screen.queryByText(/^\\s*version\\.nickname: JIRA-NNNN XYZY\\s*$/m)).toBeInTheDocument();\n    expect(screen.queryByTitle("tooltip text")).toBeInTheDocument();\n    // await userEvent.click()...\n    let after;\n    await waitFor(() => {\n        after = getHtmlNice();\n        expect(after).not.toBe(before);\n    });\n    // will show only what has changed in the HTML due to the user event.\n    expect(after).toBe(before);\n    `;

   expectToBe( getExpectations(), expectExpectations, 'getExpectations() should show test assertions to match the document' );

   const reRegex = /^regex/;
   const typeError = new TypeError( 'typeerr' );
   const aNumber = new Number( 3 );
   const aBoolean = new Boolean( false );
   const aString = new String( 'what' );
   const aDate = new Date( '2025-01-01' );
   const anObject = { a: 2 };
   const anArray = [ 1, '2', /a/g ];
   const emptyObject = {};
   const emptyArray = [];

   expectToBe( getTypeName( undefined ), '', 'getTypeName(undefined) should return empty string' );
   expectToBe( getTypeName( true ), '', 'getTypeName(true) should return empty string' );
   expectToBe( getTypeName( NaN ), '', 'getTypeName(NaN) should return empty string' );
   expectToBe( getTypeName( Infinity ), '', 'getTypeName(Infinity) should return empty string' );
   expectToBe( getTypeName( 0 ), '', 'getTypeName(0) should return empty string' );
   expectToBe( getTypeName( '' ), '', 'getTypeName("") should return empty string' );
   expectToBe( getTypeName( null ), 'Object ', 'getTypeName(null) should return Object' );
   expectToBe( getTypeName( reRegex ), 'RegExp ', 'getTypeName(RegExp) should return RegExp' );
   expectToBe( getTypeName( aDate ), 'Date ', 'getTypeName(Date) should return Date' );
   expectToBe( getTypeName( [] ), 'Array ', 'getTypeName(Array) should return Array' );
   expectToBe( getTypeName( {} ), 'Object ', 'getTypeName(Object) should return Object' );
   expectToBe( getTypeName( aNumber ), 'Number ', 'getTypeName(Number) should return Number' );
   expectToBe( getTypeName( aBoolean ), 'Boolean ', 'getTypeName(Boolean) should return Boolean' );
   expectToBe( getTypeName( aString ), 'String ', 'getTypeName(String) should return String' );
   expectToBe( getTypeName( typeError ), 'TypeError ', 'getTypeName(TypeError) should return TypeError' );
   expectToBe( getTypeName(() => null ), 'Function ', 'getTypeName(() => null) should return Function' );
   expectToBe( getTypeName( function named(): void { } ), 'Function ', 'getTypeName(function named) should return Function' );
   expectToBe( getTypeName( getTypeName ), 'Function ', 'getTypeName(getTypeName) should return Function' );

   // console.warn(`has Map?`, typeof global, typeof window, typeof global.Map, typeof document.createElement)
   // MUSTDO enable for ES6 environment...
   //expectToBe(getTypeName(new Map()), 'Map ', 'getTypeName(Map) should return Map');
   //expectToBe(getTypeName(document.createElement('input')), 'HTMLInputElement ', 'getTypeName(HTMLInputElement) should return HTMLInputElement');

   expectToBe( enquote( 'text' ), '\u201Ctext\u201D', 'enquote() should quote with left right double quotes by default' );
   expectToBe( enquote( 'text', 'lrsq' ), '\u2018text\u2019', 'enquote() should quote with left right single quotes by name' );
   expectToBe( enquote( 'text', '@' ), '@text@', 'enquote(@) should quote with a specific single character' );
   expectToBe( enquote( 'text', 'qQ' ), 'qtextQ', 'enquote(@) should quote with a specific pair of characters' );

   expectToBe( shortenDump( 'unquoted string' ), `unquoted string`, 'shortenDump() should not shorten' );
   expectToBe( shortenDump( 'unquoted string', 7 ), `unquote${EL}`, 'shortenDump(7) should shorten with ellipsis' );
   expectToBe( shortenDump( 'unquoted string', void 0, '@@' ), `@unquoted string@`, 'shortenDump(quotes:@@) should add custom quotes but not shorten it' );
   expectToBe( shortenDump( 'unquoted', 7, '@@' ), `@unquote${EL}@`, 'shortenDump(7,quotes:@@) should shorten with ellipsis and surround with custom quotes' );
   expectToBe( shortenDump( 'unquoted', 7, `${LDQ}${RDQ}` ), `${LDQ}unquote${EL}${RDQ}`, 'shortenDump(7,quotes) should shorten with ellipsis and surround with custom quotes' );
   expectToBe( shortenDump( 'unquoted\nstring' ), `unquoted\nstring`, 'shortenDump() should not shorten' );
   expectToBe( shortenDump( 'unquoted\nstring', 7 ), `unquote${EL}`, 'shortenDump(7) should shorten with ellipsis' );
   expectToBe( shortenDump( 'function () {}' ), `function () {}`, 'shortenDump(function) should not shorten function with ellipsis' );
   expectToBe( shortenDump( 'function () {}', 7 ), `function () {}`, 'shortenDump(function,7) should shorten function with ellipsis inside' );
   expectToBe( shortenDump( 'function () {}', 12 ), `function () {}`, 'shortenDump(function,12) should shorten function with ellipsis inside' );

   expectToBe( shortenDump( `${LDQ}quoted string${RDQ}`, void 0 ), `${LDQ}quoted string${RDQ}`, `shortenDump(${LDQ}${RDQ}quoted) should not shorten quoted string` );
   expectToBe( shortenDump( `${LDQ}quoted string${RDQ}`, 7 ), `${LDQ}quoted ${EL}${RDQ}`, `shortenDump(${LDQ}${RDQ}quoted,7) should not shorten inside quoted string` );
   expectToBe( shortenDump( '"quoted string"', void 0 ), `"quoted string"`, 'shortenDump("quoted) should not shorten quoted string' );
   expectToBe( shortenDump( '"quoted string"', 7 ), `"quoted ${EL}"`, 'shortenDump("quoted,7) should not shorten inside quoted string' );
   expectToBe( shortenDump( "'quoted string'", void 0 ), `'quoted string'`, "shortenDump('quoted) should not shorten quoted string" );
   expectToBe( shortenDump( "'quoted string'", 7 ), `'quoted ${EL}'`, "shortenDump('quoted,7) should not shorten inside quoted string" );
   expectToBe( shortenDump( "`quoted string`", void 0 ), '`quoted string`', "shortenDump(`quoted) should not shorten quoted string" );
   expectToBe( shortenDump( "`quoted string`", 7 ), `\`quoted ${EL}\``, "shortenDump(`quoted,7) should not shorten inside quoted string" );
   expectToBe( shortenDump( '(unquoted string)', 7 ), `(unquote${EL})`, 'shortenDump(parenthesis,7) should shorten inside theparenthesis string' );
   expectToBe( shortenDump( '<unquoted string/>', void 0 ), `<unquoted string/>`, 'shortenDump(HTML) should not shorten HTML element' );
   expectToBe( shortenDump( '<unquoted string/>', 7 ), `<unquote${EL}>`, 'shortenDump(HTML,7) should shorten the HTML element' );
   expectToBe( shortenDump( '{a:42,b:12,c:14}', void 0 ), `{a:42,b:12,c:14}`, 'shortenDump(Object) should not shorten JSON dump' );
   expectToBe( shortenDump( '{a:42,b:12,c:14}', 7 ), `{a:42,b:${EL}}`, 'shortenDump(Object,7) should shorten the JSON dump' );
   expectToBe( shortenDump( '[a,42,b,12,c,14]', void 0 ), `[a,42,b,12,c,14]`, 'shortenDump(Array) should not shorten Array JSON dump' );
   expectToBe( shortenDump( '[a,42,b,12,c,14]', 7 ), `[a,42,b,${EL}]`, 'shortenDump(Array,7) should shorten the Array JSON dump' );

   expectToBe( has( undefined ), '', 'has(undefined) should return empty string' );
   expectToBe( has( false ), false, 'has(false) should return boolean false' );
   expectToBe( has( NaN ), NaN, 'has(NaN) should return NaN' );
   expectToBe( has( Infinity ), Infinity, 'has(Infinity) should return Infinity' );
   expectToBe( has( 0 ), 0, 'has(0) should return 0' );
   expectToBe( has( '' ), '', 'has("") should return empty string' );
   expectToBe( has( null ), '', 'has(null) should return empty string' );
   expectToBe( has( reRegex ), reRegex, 'has(RegExp) should return stringified regex' );
   expectToBe( has( aDate ), aDate, 'has(Date) should return string Date' );
   expectToBe( has( emptyArray ), emptyArray, 'has(empty Array) should return empty Array with brackets' );
   expectToBe( has( emptyObject ), emptyObject, 'has(empty Object) should return stringified Object' );
   expectToBe( has( anArray ), anArray, 'has(Array) should return the Array' );
   expectToBe( has( anObject ), anObject, 'has(Object) should return the Object' );
   expectToBe( has( aNumber ), aNumber, 'has(Number) should return Number object' );
   expectToBe( has( aBoolean ), aBoolean, 'has(Boolean) should return Boolean object' );
   expectToBe( has( aString ), aString, 'has(String) should return String object itself' );
   expectToBe( has( typeError ), typeError, 'has(TypeError) should return TypeError' );
   expectToBe( has( getTypeName ), getTypeName, 'has(getTypeName) should return the Function itself' );

   expectToBe( str( undefined ), '', 'str(undefined) should return empty string' );
   expectToBe( str( false ), 'false', 'str(false) should return string false' );
   expectToBe( str( NaN ), 'NaN', 'str(NaN) should return string NaN' );
   expectToBe( str( Infinity ), 'Infinity', 'str(Infinity) should return string Infinity' );
   expectToBe( str( 0 ), '0', 'str(0) should return string 0' );
   expectToBe( str( '' ), '', 'str("") should return empty string' );
   expectToBe( str( null ), '', 'str(null) should return empty string' );
   expectToBe( str( reRegex ), '/^regex/', 'str(RegExp) should return stringified regex' );
   expectToBe( str( aDate ), 'Wed Jan 01 2025 00:00:00 GMT+0000 (Coordinated Universal Time)', 'str(Date) should return string Date' );
   expectToBe( str( [] ), '[]', 'str(empty Array) should return empty Array with brackets' );
   expectToBe( str( {} ), '[object Object]', 'str(empty Object) should return stringified Object' );
   expectToBe( str( [ 1, '2', /a/g ] ), '[1,2,/a/g]', 'str(Array) should return stringified Array with brackets' );
   expectToBe( str( { a: 2 } ), '[object Object]', 'str(Object) should return string Object' );
   expectToBe( str( aNumber ), '3', 'str(Number) should return string Number' );
   expectToBe( str( aBoolean ), 'false', 'str(Boolean) should return string Boolean' );
   expectToBe( str( aString ), 'what', 'str(String) should return String' );
   expectToBe( str( new TypeError( 'typeerr' ) ), 'TypeError: typeerr', 'str(TypeError) should return string TypeError' );
   expectToBe( str(() => null ), 'function () { return null; }', 'str(() => null) should return string Function body' );
   expectToBe( str( function named(): void { } ), 'function named() { }', 'str(function named) should return string Function body' );
   expectToBe( str( getTypeName ), `${getTypeName}`, 'str(getTypeName) should return string Function body' );

   // MUSTDO enable for ES6 environment...
   //expectToBe(str(new Map()), 'Map ', 'str(Map) should return stringified Map');
   //expectToBe(str(new Set()), 'Set ', 'str(Set) should return stringified Set');
   //expectToBe(str(document.createElement('input')), 'HTMLInputElement ', 'str(HTMLInputElement) should return HTMLInputElement');

   expectToBe( showThing(), `undefined`, 'showThing(undefined) should have no ellipsis' );
   expectToBe( showThing( null, 12 ), `null`, 'showThing(null) should have no ellipsis' );
   expectToBe( showThing( false, 12 ), `false`, 'showThing(false) should have no ellipsis' );
   expectToBe( showThing( NaN, 12 ), `NaN`, 'showThing(NaN) should have no ellipsis' );
   expectToBe( showThing( Infinity, 12 ), `Infinity`, 'showThing(Ininity) should have no ellipsis' );
   expectToBe( showThing( -Infinity, 12 ), `-Infinity`, 'showThing(Ininity) should have no ellipsis' );
   expectToBe( showThing( 123456789012, 12 ), `123456789012`, 'showThing(123456789012) should have no ellipsis' );
   expectToBe( showThing( '123456789012', 12 ), `${LDQ}123456789012${RDQ}`, 'showThing("123456789012") should have no ellipsis' );
   expectToBe( showThing( /^regexpres/, 12 ), `/^regexpres/`, 'showThing(/^regexpres/) should have no ellipsis' );
   expectToBe( showThing( aDate, 142 ), `Wed Jan 01 2025 00:00:00 GMT+0000 (Coordinated Universal Time)`, 'showThing(Date,142) should have no ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 12 ), `[1,2,3,4,52]`, 'showThing(Array) should have no ellipsis' );
   expectToBe( showThing( { a: 1, b: 2 }, 14 ), `{"a":1,"b":2}`, 'showThing(small Object,13) should have no ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, ddd: 4 }, 12 ), `keys: [a, b, c, ddd]`, 'showThing(Object/k) should have keys and no ellipsis' );
   expectToBe( showThing( new Number( 123456789012 ), 12 ), `123456789012`, 'showThing(Number) should have no ellipsis' );
   expectToBe( showThing( new Boolean( false ), 12 ), `false`, 'showThing(Boolean) should have no ellipsis' );
   expectToBe( showThing( new String( '123456789012' ), 12 ), `${LDQ}123456789012${RDQ}`, 'showThing(String) should have no ellipsis' );
   expectToBe( showThing( new TypeError( 'blah' ), 15 ), `TypeError: blah`, 'showThing(TypeError) should have no ellipsis' );
   expectToBe( showThing(() => null, 28 ), `function () { return null; }`, 'showThing(arrow function) should have no ellipsis' );
   expectToBe( showThing( function (): void { }, 15 ), `function () { }`, 'showThing(anon function) should have no ellipsis' );
   expectToBe( showThing( function named(): void { }, 20 ), `function named() { }`, 'showThing(named function) should have no ellipsis' );
   expectToBe( showThing( noop, 19 ), `function noop() { }`, 'showThing(function name) should have no ellipsis' );

   expectToBe( showThing( undefined, 2 ), `un${EL}`, 'showThing(undefined,2) should have ellipsis' );
   expectToBe( showThing( null, 2 ), `nu${EL}`, 'showThing(null,2) should have ellipsis' );
   expectToBe( showThing( false, 2 ), `fa${EL}`, 'showThing(false,2) should have ellipsis' );
   expectToBe( showThing( NaN, 2 ), `Na${EL}`, 'showThing(NaN,2) should have ellipsis' );
   expectToBe( showThing( Infinity, 2 ), `In${EL}`, 'showThing(Ininity,2) should have ellipsis' );
   expectToBe( showThing( -Infinity, 2 ), `-I${EL}`, 'showThing(-Ininity,2) should have ellipsis' );
   expectToBe( showThing( 123456789012, 2 ), `12${EL}`, 'showThing(123456789012,2) should have ellipsis' );
   expectToBe( showThing( '123456789012', 2 ), `${LDQ}12${EL}${RDQ}`, 'showThing("123456789012",2) should have ellipsis' );
   expectToBe( showThing( '123456789AB', 12 ), `${LDQ}123456789AB${RDQ}`, 'showThing(short string) should have no ellipsis' );
   expectToBe( showThing( '123456789ABC', 12 ), `${LDQ}123456789ABC${RDQ}`, 'showThing(just right) should have no ellipsis' );
   expectToBe( showThing( '123456789ABCD', 12 ), `${LDQ}123456789ABC${EL}${RDQ}`, 'showThing(longer string) should have no ellipsis' );
   expectToBe( showThing( /^regexpres/, 2 ), `/^${EL}/`, 'showThing(/^regexpres/,2) should have ellipsis' );
   expectToBe( showThing( aDate, 2 ), `We${EL}`, 'showThing(Date,2) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 2 ), `[1,${EL}]`, 'showThing(Array,2) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 3 ), `[1,2${EL}]`, 'showThing(Array,3) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 4 ), `[1,2,${EL}]`, 'showThing(Array,4) should have ellipsis' );
   expectToBe( showThing( { a: 1, b: 2 }, 2 ), `keys: [a,${EL}]`, 'showThing(Object,2) should have keys and ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, ddd: 4 }, 2 ), `keys: [a,${EL}]`, 'showThing(Object/k,2) should have keys and ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, dddd: 4 }, 12 ), `keys: [a, b, c, ddd_]`, 'showThing(Object/k,12) should have keys and ellipsis' );
   expectToBe( showThing( new Boolean( false ), 2 ), `fa${EL}`, 'showThing(Boolean,2) should have ellipsis' );
   expectToBe( showThing( new Number( 123456789012 ), 2 ), `12${EL}`, 'showThing(Number,2) should have ellipsis' );
   expectToBe( showThing( new String( '123456789012' ), 2 ), `${LDQ}12${EL}${RDQ}`, 'showThing(String,2) should have ellipsis' );
   expectToBe( showThing( new TypeError( 'blah' ), 2 ), `Ty${EL}`, 'showThing(TypeError,2) should have ellipsis' );
   expectToBe( showThing(() => null, 11 ), `function () { return${EL}}`, 'showThing(arrow function,11) should have ellipsis' );
   expectToBe( showThing( function (): string { return 'S' }, 11 ), `function () { return${EL}}`, 'showThing(anon function,11) should have ellipsis' );
   expectToBe( showThing( function named(): void { }, 8 ), `function named() ${EL}}`, 'showThing(named function,8) should have ellipsis' );
   expectToBe( showThing( noop, 8 ), `function noop() {${EL}}`, 'showThing(function name,8) should have ellipsis' );

   // MUSTDO enable for ES6 environment...
   // const setSm = new Set([1,2,3,4,52]);
   // const mapSm = new Map([['a',1],['b',2]]);
   // const mapLg = new Map([['a',1],['b',2],['c',3],['dddd',4]]);
   // expectToBe(showThing(setSm, 12), `[1,2,3,4,52]`, 'showThing(Set) should have no ellipsis');
   // expectToBe(showThing(mapSm,14), `{"a":1,"b":2}`, 'showThing(small Map,13) should have no ellipsis');
   // expectToBe(showThing(setSm, 4), `[1,2${EL}]`, 'showThing(Set,4) should have ellipsis');
   // expectToBe(showThing(mapLg, 12), `keys: [a, b, c, ddd_]`, 'showThing(Map/k,12) should have keys and ellipsis');
   // const inEl = document.createElement('input');
   // inEl.setAttribute('name', 'phone');
   // inEl.setAttribute('placeholder', 'your phone number?');
   // expectToBe(showThing(inEl, 52), `[1,2,3,4,52]`, 'showThing(HTMLInputElement) should have no ellipsis');
   // expectToBe(showThing(inEl, 12), `[1,2,3,4,52]`, 'showThing(HTMLInputElement) should have ellipsis');

   const elDump: any = {
	  __reactInternalInstance1234: {
	  }
   };
   expectToBe( getElementInfo( elDump ), `NOT ELEM??? object Object  {"__reactInternalInstance1234":{}}`, 'getElementInfo(not) should respond with NOT ELEM??? message' );

   elDump.tagName = 'TAGNAME';
   elDump.src = 'SRC-omitted';
   elDump.id = 'ID';
   elDump.type = 'TEXT';
   elDump.role = 'ROLE';
   elDump[ 'aria-role' ] = 'AROLE';
   elDump.disabled = 'DISABLED';
   elDump.height = 'HEIGHT';
   elDump.tabIndex = 'TABINDEX';
   elDump[ 'aria-label' ] = 'ARLABEL';
   elDump.selected = 'SELECTED';
   elDump[ 'aria-invalid' ] = 'ARINVALID';
   elDump.placeholder = 'PLACEHOLDER';
   elDump.className = 'CLASSNAME';
   elDump.__reactInternalInstance1234 = {
	  elementType: 'REACTELEM',
	  pendingProps: {
		 id: 'IDp',
		 'data-testid': 'DATA-TESTIDp',
		 role: 'ROLEp',
		 target: 'TARGETp',
		 focusable: 'FOCUSABLEp',
		 hidden: 'HIDDENp',
		 'for': 'FORp',
		 value: 'VALUEp',
		 checked: 'CHECKEDp',
		 'aria-expanded': 'AREXPANDEDp',
		 alt: 'ALTp',
	  },
	  memoizedProps: {
		 id: 'IDm',
		 name: 'NAMEm',
		 role: 'ROLEm',
		 rel: 'RELm',
		 width: 'WIDTHm',
		 'aria-hidden': 'ARHIDDENm',
		 label: 'LABELm',
		 defaultValue: 'DEFVALUEm',
		 'aria-checked': 'ARCHECKEDm',
		 title: 'TITLEm',
		 href: 'HREFm',
	  },
   };

   expectToBe( getElementInfo(), `NOT ELEM??? undefined  undefined`, 'getElementInfo() should show NOT ELEM message' );
   if ( showAllPropSources )
   {
	  expectToBe( showThing( elDump ), `<REACTELEM#ID/IDp/IDm[data-testid="/DATA-TESTIDp/"][name="//NAMEm"][type="TEXT//"][role="ROLE/ROLEp/ROLEm"][aria-role="AROLE//"][_>`, 'showThing(Element/React1) should show the element shortened' );
	  expectToBe( getElementInfo( elDump ), `<REACTELEM#ID/IDp/IDm[data-testid="/DATA-TESTIDp/"][name="//NAMEm"][type="TEXT//"][role="ROLE/ROLEp/ROLEm"][aria-role="AROLE//"][target="/TARGETp/"][rel="//RELm"][disabled="DISABLED//"][focusable="/FOCUSABLEp/"][width="//WIDTHm"][height="HEIGHT//"][hidden="/HIDDENp/"][aria-hidden="//ARHIDDENm"][tabIndex="TABINDEX//"][for="/FORp/"][label="//LABELm"][aria-label="ARLABEL//"][value="/VALUEp/"][defaultValue="//DEFVALUEm"][selected="SELECTED//"][checked="/CHECKEDp/"][aria-checked="//ARCHECKEDm"][aria-invalid="ARINVALID//"][aria-expanded="/AREXPANDEDp/"][title="//TITLEm"][placeholder="PLACEHOLDER//"][alt="/ALTp/"][href="//HREFm"].CLASSNAME//. Object />`, 'getElementInfo(Element/React1) should respond with Element and React values' );
   } else
   {
	  expectToBe( showThing( elDump ), `<REACTELEM#ID[data-testid="DATA-TESTIDp"][name="NAMEm"][type="TEXT"][role="ROLE"][aria-role="AROLE"][target="TARGETp"][rel="RELm"_>`, 'showThing(Element/React2) should show the element shortened' );
	  expectToBe( getElementInfo( elDump ), `<REACTELEM#ID[data-testid="DATA-TESTIDp"][name="NAMEm"][type="TEXT"][role="ROLE"][aria-role="AROLE"][target="TARGETp"][rel="RELm"][disabled="DISABLED"][focusable="FOCUSABLEp"][width="WIDTHm"][height="HEIGHT"][hidden="HIDDENp"][aria-hidden="ARHIDDENm"][tabIndex="TABINDEX"][for="FORp"][label="LABELm"][aria-label="ARLABEL"][value="VALUEp"][defaultValue="DEFVALUEm"][selected="SELECTED"][checked="CHECKEDp"][aria-checked="ARCHECKEDm"][aria-invalid="ARINVALID"][aria-expanded="AREXPANDEDp"][title="TITLEm"][placeholder="PLACEHOLDER"][alt="ALTp"][href="HREFm"].CLASSNAME. Object />`, 'getElementInfo(Element/React2) should respond with Element and React values' );
   }

   delete elDump.__reactInternalInstance1234;
   if ( showAllPropSources )
   {
	  expectToBe( getElementInfo( elDump ), `<TAGNAME#ID//[type="TEXT//"][role="ROLE//"][aria-role="AROLE//"][disabled="DISABLED//"][height="HEIGHT//"][tabIndex="TABINDEX//"][aria-label="ARLABEL//"][selected="SELECTED//"][aria-invalid="ARINVALID//"][placeholder="PLACEHOLDER//"].CLASSNAME//. Object />`, 'getElementInfo(Element1) should respond with Element values only' );
   } else
   {
	  expectToBe( getElementInfo( elDump ), `<TAGNAME#ID[type="TEXT"][role="ROLE"][aria-role="AROLE"][disabled="DISABLED"][height="HEIGHT"][tabIndex="TABINDEX"][aria-label="ARLABEL"][selected="SELECTED"][aria-invalid="ARINVALID"][placeholder="PLACEHOLDER"].CLASSNAME. Object />`, 'getElementInfo(Element2) should respond with Element values only' );
   }

   // MUSTDO enable for browser/DOM environment...
   //console.warn(`getElementInfo`, getElementInfo(inEl))
   //expectToBe(getElementInfo(inEl), `<INPUT />`, 'getElementInfo(HTMLInputElement) should respond with HTMLInputElement values');

   expectToBe( showEvent(), `NOT EVENT??? undefined  undefined`, `showEvent() should show NOT EVENT message` );
   const event = {
	  timestamp: '1719410356201',
	  type: 'CLICK',
	  eventPhase: '3',
	  isTrusted: true,
	  bubbles: true,
	  cancellable: true,
	  defaultPrevented: true,
	  isPersistent: true,
	  isDefaultPrevented: true,
	  isPropagationStopped: true,

	  details: 'DETAILS',

	  metaKey: true,
	  ctrlKey: false,
	  shiftKey: true,
	  altKey: false,
	  getModifierState: 'MODSTATE',
	  button: 'BUTTON',
	  buttons: 'BUTTONs',

	  screenX: 12,
	  screenY: 43,
	  clientX: 23,
	  clientY: 0,
	  pageX: 0,
	  pageY: 32,
	  movementX: 0,
	  movementY: 0,

	  nativeEvent: {},
	  dispatchConfig: {
		 phasedRegistrationNames: [ 'ONCLICK', 'ONCLICKCAPTURE' ],
	  },
	  // Elements
	  target: elDump,
	  currentTarget: openInput,
	  relatedTarget: dialogElOpen,
	  view: { what: 'VIEW' },
   };
   // console.warn(`showEvent`, showEvent(event))

   let targetDump = `<TAGNAME#ID//[type="TEXT//"][role="ROLE//"][aria-role="AROLE//"][disabled="DISABLED//"][height="HEIGHT//"][tabIndex="TABINDEX//"][aria-label="ARLABEL//"][selected="SELECTED//"][aria-invalid="ARINVALID//"][placeholder="PLACEHOLDER//"].CLASSNAME//. Object />`;
   if ( !showAllPropSources )
   {
	  targetDump = targetDump.replace( /\/\//g, '' );
   }
   const currentDump = `<input Object />`;
   const relatedDump = `<div Object />`;

   expectToBe( showEvent( event, 'PREFIX:' ), `PREFIX:EVENT Object CLICK/@1719410356201 ONCLICK ONCLICKCAPTURE eventPhase(3) isTrusted bubbles cancellable defaultPrevented isPersistent isDefaultPrevented isPropagationStopped \ndetails(DETAILS) metaKey shiftKey \nbutton buttons screenXY(12,43)clientXY(23,0)pageXY(0,32)\ntarget: ${targetDump}\ncurrentTarget: ${currentDump}\nrelatedTarget: ${relatedDump}\nview: object Object  {"what":"VIEW"}`, `showEvent(event) should show event details` );

   const spacesHyphens = '  \f\n\r\t\v | \x20 \x09 \x0a \x0b \x0c \x0d \x0d\x0a \xa0 \xad | \u0020 \u0009 \u000a \u000b \u000c \u000d \u000d\u000a \u00a0 \u00ad \u202F \uFEFF \u2000 \u2001 \u2002 \u2003 \u2004 \u2005 \u2006 \u2007 \u2008 \u2009 \u200A \u200B \u205F \u3000 \u303F \u2010 \u2011 \u2027 \uFE63 \uFF0D';

   EX_AS_JS = true;
   expectToBe( indicateSpaces( spacesHyphens ), `[SPx2][FF]\n[LF]\n[CR]\n[TAB][VT]\n |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] [NARROW.NBSP] [ZERO.NBSP] [EN.QUAD] [EM.QUAD] [EN.SPACE] [EM.SPACE] [THREE.PER.EM.SPACE] [FOUR.PER.EM.SPACE] [SIX.PER.EM.SPACE] [FIGURE.SPACE] [PUNCT.SPACE] [THIN.SPACE] [HAIR.SPACE] [ZERO.SPACE] [MED.MATH.SPACE] [IDEOGRAPHIC.SPACE] [IDEOGRAPHIC.HALF.FILL.SPACE] [HYPHEN] [NB.HYPHEN] [HYPHEN.POINT] [SMALL.HYPHEN] [FULL.WIDTH.HYPHEN]`, 'indicateSpaces() should show various white space and hypens as [TEXT]' );
   expectToBe( indicateSpaces( replaceCharsCodePt( spacesHyphens ) ), `[SPx2][FF]\n[LF]\n[CR]\n[TAB][VT]\n |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] [U+202F] [U+FEFF] [U+2000] [U+2001] [U+2002] [U+2003] [U+2004] [U+2005] [U+2006] [U+2007] [U+2008] [U+2009] [U+200A] [U+200B] [U+205F] [U+3000] [U+303F] [U+2010] [U+2011] [U+2027] [U+FE63] [U+FF0D]`, 'replaceCharsCodePt() should show all unicode code points in the string.' );

   testSummary();
