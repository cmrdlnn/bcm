import { history } from 'store';

import { request } from 'api';

import { AUTH_CHECK } from '../constants';

export default function () {
  return (dispatch) => {
    const token = localStorage.getItem('X-CSRF-Token');

    if (token) {
      request('/api/auth/check')
        .then(
          response => response.json()
            .then((payload) => {
              dispatch({
                type: AUTH_CHECK,
                payload,
              });
              if (history.location.pathname === '/login') history.push('/');
            }),
          () => {
            dispatch({ type: AUTH_CHECK });
            history.push('/login');
          },
        );
    } else {
      dispatch({ type: AUTH_CHECK });
      history.push('/login');
    }
  };
}
