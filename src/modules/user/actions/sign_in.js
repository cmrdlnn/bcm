import { history } from 'store';

import { JSONRequest } from 'api';

import { SIGN_IN } from '../constants';

export default function (data) {
  return (dispatch) => {
    const credentials = { ...data, login: data.login.trim().toLowerCase() }

    JSONRequest('/api/auth', credentials)
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
