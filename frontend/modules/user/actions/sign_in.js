import { JSONRequest } from 'api';

import { SIGNIN } from '../constants';

export default function () {
  return (dispatch) => {
    JSONRequest('/login')
      .then((payload) => {
        dispatch({
          type: SIGNIN,
          payload
        });
      })
      .then(() => window.location.replace('/'));
  };
}
