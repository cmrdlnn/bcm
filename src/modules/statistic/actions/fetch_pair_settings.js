import { request } from 'api';

import { FETCH_PAIR_SETTINGS } from '../constants';

export default function () {
  return (dispatch) => {
    request('/api/pair_settings')
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: FETCH_PAIR_SETTINGS,
          payload,
        });
      });
  };
}
