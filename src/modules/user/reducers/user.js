import {
  AUTH_CHECK,
  CHANGE_EMAIL,
  FETCH_INFO,
  LOGOUT,
  SIGN_IN,
} from '../constants';

export default function reducer(state = { fetching: true }, { type, payload }) {
  switch (type) {
    case AUTH_CHECK:
      return payload || {};

    case CHANGE_EMAIL:
      return payload;

    case FETCH_INFO:
      return { ...state, ...payload };

    case LOGOUT:
      return {};

    case SIGN_IN:
      return payload;

    default:
      return state;
  }
}
