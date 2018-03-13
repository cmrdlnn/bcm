import { history } from 'store';

import { JSONRequest } from 'api';

import { UPDATE_USER } from 'modules/user/constants';
import { TRADE_CREATE } from '../constants';

export default function (data) {
  return (dispatch, getState) => {
    const { user } = getState();
    const nonCredentialsProps = {};
    const credentials = Object.keys(user).reduce((result, key) => {
      if (['key', 'secret'].includes(key)) {
        result[key] = user[key];
      } else {
        nonCredentialsProps[key] = user[key];
      }
      return result;
    }, {});

    JSONRequest('/api/trades', { ...data, ...credentials })
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: TRADE_CREATE,
          payload,
        });
        dispatch({
          type: UPDATE_USER,
          payload: nonCredentialsProps,
        });
        history.push(`/trades/${payload.id}`);
      });
  };
}
