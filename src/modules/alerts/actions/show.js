import { ALERT_SHOW } from '../constants';

export default function (message) {
  return {
    type: ALERT_SHOW,
    payload: message
  };
}
