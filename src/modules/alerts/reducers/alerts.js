import { ALERT_HIDE, ALERT_SHOW } from '../constants';

export default function reducer(state = [], { type, payload }) {
  switch (type) {
    case ALERT_HIDE: {
      const index = state.indexOf(payload);
      return [...state.slice(0, index), ...state.slice(index + 1)];
    }

    case ALERT_SHOW:
      return [...state, { headline: 'Ошибка!', id: Date.now(), message: payload, type: 'danger' }];

    default:
      return state;
  }
}
