import { ALERT_SHOW } from '../constants';

export default function (message, type = 'danger') {
  const payload = { id: Date.now(), message, type };

  switch (type) {
    case 'danger':
      payload.headline = 'Ошибка!';
      break;

    case 'success':
      payload.headline = 'Успешно';
      break;
  }

  return {
    type: ALERT_SHOW,
    payload,
  };
}
