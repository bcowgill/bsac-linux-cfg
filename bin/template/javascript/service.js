// service.js
// a service which is mockable if testing but fixed otherwise.
// a service can be a function or any object.

export default function makeService(service) {
  let mockService = service;

  function setMock (mock = service) {
    const oldService = mockService;
    if (process.env.NODE_ENV === 'test') {
      mockService = mock;
    }
    return oldService;
  }

  function isMock () {
    return mockService !== service;
  }

  function use () {
    return mockService;
  }

  return { use, setMock, isMock };
}


// pseudo code how to use when testing...
const api = makeService(window.fetch);

afterEach(() => api.setMock());

const spy = jest.fn().mockImplementationOnce(42);
api.setMock(spy);
api.use()('/path/to/api');
expect(spy).toHaveBeenCalledTimes(1);
expect(spy).toHaveBeenCalledWith('/path/to/api');

// pseudo code how to use in some object...

const api = makeService(window.fetch);

export const setMockFetch = api.setMock;

export function get(path) {
  return api.use()(path);
}
