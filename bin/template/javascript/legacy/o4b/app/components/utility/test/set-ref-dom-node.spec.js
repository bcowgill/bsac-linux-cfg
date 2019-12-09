/* eslint-disable prefer-arrow-callback */
import sinon from 'sinon';
import ReactDOM from 'react-dom';
import { expectObjectsDeepEqual } from '../../../utility/testing-utilities';
import setRefDOMNode from '../set-ref-dom-node';

const suite = 'app/components/utility/test/set-ref-dom-node.spec.js';

describe(suite, function descSetRefDomNodeSuite() {
  let domSpy;
  beforeEach(function setupTest() {
    domSpy = sinon
      .stub(ReactDOM, 'findDOMNode')
      .returns('this is the DOM node');
  });
  afterEach(function tearDownTest() {
    if (domSpy) {
      domSpy.restore();
      domSpy = null;
    }
  });

  it('should store the DOM node in the object', function testSetRefDomNode() {
    function Make() {
      // like constructor() in a react component
      this.setRef = setRefDOMNode('hello').bind(this);
    }

    const expected = { hello: 'this is the DOM node' };
    const actual = new Make();

    // called from within sub components ref={this.setRef}
    actual.setRef('some node');

    expect(actual.setRef).toEqual(jasmine.any(Function));
    expect(actual.domNode).toEqual(expected);
    expect(domSpy.callCount).toBe(1);
    expect(domSpy.lastCall.args[0]).toBe('some node');
  });

  it('should store the DOM node in an array too', function testSetRefDomNodeArray() {
    function Make() {
      // like constructor() in a react component
      this.domNode = [];
      this.setRef = [setRefDOMNode(0).bind(this), setRefDOMNode(1).bind(this)];
    }

    const expected = ['this is the DOM node', 'this is the DOM node'];
    const actual = new Make();

    // called from within sub components ref={this.setRef[0]}
    actual.setRef[0]('some node');
    actual.setRef[1]('some other node');

    expect(actual.setRef).toEqual(jasmine.any(Array)); // instanceof test
    expectObjectsDeepEqual(actual.domNode, expected);
    expect(domSpy.callCount).toBe(2);
    expect(domSpy.firstCall.args[0]).toBe('some node');
    expect(domSpy.lastCall.args[0]).toBe('some other node');
  });
});
