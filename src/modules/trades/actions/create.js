import { history } from 'store';

import { JSONRequest } from 'api';

import { TRADE_CREATE } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/trades', { ...data, pair: 'BTC_USD' })
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
