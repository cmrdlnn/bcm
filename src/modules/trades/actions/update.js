import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

import { TRADE_UPDATE } from '../constants';

export default function (id, data, onSuccessMessage = null) {
  return (dispatch) => {
    JSONRequest(`/api/trades/${id}`, data, 'PUT')
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: TRADE_UPDATE,
          payload,
        });
        if (onSuccessMessage) dispatch(showAlert(onSuccessMessage, 'success'));
      });
  };
}
