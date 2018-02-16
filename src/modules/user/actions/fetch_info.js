import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

import { FETCH_INFO } from '../constants';

export default function (data) {
  return (dispatch) => {
    JSONRequest('/api/trades/user_info', data)
      .then(response => response.json())
      .then((payload) => {
        if (payload.balances) {
          dispatch({
            type: FETCH_INFO,
            payload: { ...payload, ...data },
          });
        } else {
          dispatch(
            showAlert('По данным ключам аккаунт не найден'),
          );
        }
      });
  };
}
