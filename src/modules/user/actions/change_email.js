import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

import { CHANGE_EMAIL } from '../constants';

export default function (data) {
  return (dispatch, getState) => {
    const { id } = getState().user;

    JSONRequest('/api/users/change_email', { id, ...data })
      .then(response => response.json())
      .then((payload) => {
        dispatch({
          type: CHANGE_EMAIL,
          payload,
        });
        dispatch(
          showAlert('e-mail успешно изменён', 'success'),
        );
      });
  };
}
