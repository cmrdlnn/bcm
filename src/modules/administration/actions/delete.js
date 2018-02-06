import { request } from 'api';

import { DELETE } from '../constants';

export default function (id) {
  return (dispatch) => {
    request('api/users', null, 'DELETE')
      .then(() => {
        dispatch({
          type: DELETE,
          payload: id
        });
      });
  };
}
