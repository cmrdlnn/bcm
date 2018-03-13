import {
  AUTH_CHECK,
  LOGOUT,
  SIGN_IN,
  UPDATE_USER,
} from '../constants';

export default function reducer(state = { fetching: true }, { type, payload }) {
  switch (type) {
    case AUTH_CHECK:
      return payload || {};

    case LOGOUT:
      return {};

    case SIGN_IN:
      return payload;

    case UPDATE_USER:
      return { ...state, ...payload };

    default:
      return state;
  }
}
