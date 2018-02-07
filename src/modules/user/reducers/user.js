import { AUTHENTICATION_CHECK, SIGN_IN } from '../constants';

export default function reducer(state = { fetching: true }, { type, payload }) {
  switch (type) {
    case AUTHENTICATION_CHECK:
      return payload || {};

    case SIGN_IN:
      return payload;

    default:
      return state;
  }
}
