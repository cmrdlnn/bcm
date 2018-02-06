import { JSONRequest } from 'api';

import { CREATE } from '../constants';

export default function () {
  return (dispatch) => {
    JSONRequest('/check_authentification')
      .then((payload) => {
        dispatch({
          type: CREATE,
          payload
        });
      });
  };
}
