import { JSONRequest } from 'api';

import { showAlert } from 'modules/alerts';

export default function (data) {
  return (dispatch, getState) => {
    const { id } = getState().user;
    const credentials = { ...data, new_email: data.new_email.trim().toLowerCase() }

    JSONRequest('/api/users/change_email', { id, ...credentials }, 'PATCH')
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
