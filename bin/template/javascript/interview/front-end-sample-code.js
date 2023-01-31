import PropTypes from "prop-types";
import { useRef, useEffect } from "react";
import track, { OPEN, CLOSE } from "tracking/track";

const displayName = "TrackOpenClose";

function TrackOpenClose({ isOpen, event, options }) {
  const openState = useRef(false);

  useEffect(
    function () {
      if (event && !isOpen !== !openState.current) {
        track(event, { ...options, type: isOpen ? OPEN : CLOSE });
        openState.current = isOpen ? [event, options] : false;
      }
    },
    [isOpen, event, options]
  );

  useEffect(function () {
    return function componentWillUnmount() {
      if (openState.current) {
        const [event, options] = openState.current;
        track(event, { ...options, type: CLOSE });
        openState.current = false;
      }
    };
  }, []);

  return null;
}
TrackOpenClose.displayName = displayName;
TrackOpenClose.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  event: PropTypes.string,
  options: PropTypes.object,
};
TrackOpenClose.defaultProps = {
  trackOptions: {},
};

export default TrackOpenClose;
