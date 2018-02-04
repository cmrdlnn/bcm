import { AUTHENTICATION_CHECK, SIGNIN } from '../constants';

export default function reducer(state = { fetching: true }, { type, payload }) {
  switch (type) {
    case AUTHENTICATION_CHECK:
      return payload || {};

    case SIGNIN:
      return payload;

    default:
      return state;
  }
}
