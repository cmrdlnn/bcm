import { history } from 'store';

import { request } from 'api';

import { AUTH_CHECK } from '../constants';

export default function () {
  return (dispatch) => {
    const token = localStorage.getItem('X-CSRF-Token');

    if (token) {
      request('/api/auth/check')
        .then(response => response.json())
        .then((payload) => {
          history.push('/');
          dispatch({
            type: AUTH_CHECK,
            payload,
          });
        });
    } else {
      dispatch({ type: AUTH_CHECK });
      history.push('/login');
    }
  };
}
