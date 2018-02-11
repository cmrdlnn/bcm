import { JSONRequest } from 'api';

import { FETCH_INFO } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/user_info', data)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: FETCH_INFO,
          payload: { ...payload, ...data },
        });
      });
  };
}
