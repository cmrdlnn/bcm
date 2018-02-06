import { history } from 'store';

import { JSONRequest } from 'api';

import { AUTH } from '../constants';

export default function () {
  return (dispatch) => {
    JSONRequest('/api/auth')
      .then((payload) => {
        dispatch({
          type: AUTH,
          payload
        });
        history.push('/');
      });
  };
}
