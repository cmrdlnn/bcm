import { objectToParams, request } from 'api';

import { TRADES_INDEX } from '../constants';

export default function (data) {
  return (dispatch) => {
    request(`/api/trades${objectToParams(data)}`)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: TRADES_INDEX,
          payload,
        });
      });
  };
}
