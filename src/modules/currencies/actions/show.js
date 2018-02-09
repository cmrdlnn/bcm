import { request } from 'api';

import { CURRENCIES_SHOW } from '../constants';

export default function (data) {
  return (dispatch) => {
    request('/api/course', data)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: CURRENCIES_SHOW,
          payload,
        });
      });
  };
}
