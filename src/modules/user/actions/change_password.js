import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

export default function (data) {
  return (dispatch, getState) => {
    const { id } = getState().user;

    JSONRequest('/api/users/change_password', { id, ...data })
      .then(response => response.json())
      .then(() => {
        dispatch(
          showAlert('Пароль успешно изменён', 'success'),
        );
      });
  };
}
