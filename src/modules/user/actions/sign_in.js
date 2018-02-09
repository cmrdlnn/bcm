import { history } from 'store';

import { JSONRequest } from 'api';

import { SIGN_IN } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/auth', data)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: SIGN_IN,
          payload,
        });
        history.push('/');
      });
  };
}
