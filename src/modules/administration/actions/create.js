import { JSONRequest } from 'api';

import { USER_CREATE } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/users', data)
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: USER_CREATE,
          payload,
        });
      });
  };
}
