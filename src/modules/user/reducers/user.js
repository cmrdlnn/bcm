import { AUTHENTICATION_CHECK, AUTH } from '../constants';

export default function reducer(state = { fetching: true }, { type, payload }) {
  switch (type) {
    case AUTHENTICATION_CHECK:
      return payload || {};

    case AUTH:
      return payload;

    default:
      return state;
  }
}
