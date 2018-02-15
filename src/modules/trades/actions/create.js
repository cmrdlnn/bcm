import { history } from 'store';

import { JSONRequest } from 'api';

import { TRADE_CREATE } from '../constants';

export default function (data) {
  return (dispatch, getState) => {
    const { user } = getState();
    const credentials = Object.keys(user).reduce((result, key) => {
      if (['key', 'secret'].includes(key)) result[key] = user[key];
      return result;
    }, {});

    JSONRequest('/api/trades', { ...data, ...credentials, pair: 'BTC_USD' })
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: TRADE_CREATE,
          payload,
        });
        history.push(`/trades/${payload.id}`);
      });
  };
}
