import { request } from 'api';

import { FETCH_TICKER } from '../constants';

export default function () {
  return (dispatch) => {
    request('/api/course')
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: FETCH_TICKER,
          payload,
        });
      });
  };
}
