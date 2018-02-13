import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

export default function (data) {
  return (dispatch, getState) => {
    const { id } = getState().user;

    JSONRequest('/api/users/change_password', { id, ...data }, 'PATCH')
      .then(() => {
        dispatch(
          showAlert('Пароль успешно изменён', 'success'),
        );
      });
  };
}
