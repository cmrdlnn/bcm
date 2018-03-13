import { objectToParams, request } from 'api';

import { FETCH_ORDER_BOOK } from '../constants';

export default function (pair) {
  return (dispatch) => {
    request(`/api/order_book${objectToParams({ limit: '10', pair })}`)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: FETCH_ORDER_BOOK,
          payload: payload[pair],
        });
      });
  };
}
