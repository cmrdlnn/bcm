import { history } from 'store';

import { JSONRequest } from 'api';

import { ALERT_SHOW } from 'modules/alerts/constants';
import { SIGN_IN } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/auth', data)
      .then((payload) => {
        dispatch({
          type: SIGN_IN,
          payload
        })
        history.push('/');
      })
      .catch(response => response.json().then((json) => {
        dispatch({
          type: ALERT_SHOW,
          payload: json.message
        });
      }));
  };
}
