import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

export default function (data) {
  return (dispatch, getState) => {
    const { id } = getState().user;

    JSONRequest('/api/users/change_email', { id, ...data }, 'PATCH')
      .then(() => {
        dispatch(
          showAlert(
            'E-Mail успешно изменён, Вам необходимо подтвердить его смену, проверьте указанный адрес',
            'success',
          ),
        );
      });
  };
}
