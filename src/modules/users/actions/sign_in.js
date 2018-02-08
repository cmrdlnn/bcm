import { JSONRequest } from 'api';

import { SIGN_IN } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/auth', data)
      .then((payload) => {
        dispatch({
          type: SIGN_IN,
          payload
        });
      });
  };
}
