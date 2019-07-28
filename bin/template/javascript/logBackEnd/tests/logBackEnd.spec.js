import * as logger from '../logBackEnd';

describe('commons/debug/logBackEnd', () => {
  const fetch = logger.fetch;

  afterEach(() => {
    logger.setFetch(fetch);
  });

  it('should POST the payload to the api endpoint', () => {
    const fetchSpy = jest.fn();

    logger.setFetch(fetchSpy);
    logger.logBackEnd('a\nb\nc\n');
    expect(fetchSpy).toHaveBeenCalledWith(undefined, {
      method: 'POST',
      body: 'a\nb\nc\n',
    });
  });
});
