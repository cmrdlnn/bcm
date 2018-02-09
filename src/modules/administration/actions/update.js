import { JSONRequest } from 'api';

import { USER_UPDATE } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest(`/api/users/${data.id}`, data, 'PUT')
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: USER_UPDATE,
          payload
        });
      });
  };
}
