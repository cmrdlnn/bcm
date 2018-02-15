import { request } from 'api';

import { TRADE_FETCH } from '../constants';

export default function (id) {
  return (dispatch) => {
    request(`/api/trades/${id}`)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: TRADE_FETCH,
          payload,
        });
      });
  };
}
