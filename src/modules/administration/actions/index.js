import { request } from 'api';

import { INDEX } from '../constants';

export default function () {
  return (dispatch) => {
    request('api/users')
      .then((payload) => {
        dispatch({
          type: INDEX,
          payload
        });
      });
  };
}
