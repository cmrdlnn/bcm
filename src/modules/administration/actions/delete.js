import { request } from 'api';

import { showAlert } from 'modules/alerts';

import { USER_DELETE } from '../constants';

export default function (id) {
  return (dispatch) => {
    request(`/api/users/${id}`, null, 'DELETE')
      .then(() => {
        dispatch({
          type: USER_DELETE,
          payload: id,
        });
        dispatch(showAlert('Пользователь успешно удалён', 'success'));
      });
  };
}
