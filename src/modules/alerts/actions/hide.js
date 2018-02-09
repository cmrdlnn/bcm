import { ALERT_HIDE } from '../constants';

export default function (alert) {
  return {
    type: ALERT_HIDE,
    payload: alert
  };
}
