import { history } from 'store';

import { JSONRequest } from 'api';

import { AUTHENTICATION_CHECK } from '../constants';

export default function () {
  return (dispatch) => {
    const token = localStorage.getItem('X-CSRF-Token');

    if (token) {
      JSONRequest('/check_authentification')
        .then((payload) => {
          dispatch({
            type: AUTHENTICATION_CHECK,
            payload
          });
          history.push('/');
        });
    } else {
      dispatch({ type: AUTHENTICATION_CHECK });
      // history.push('/login');
    }
  };
}
