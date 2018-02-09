import { CURRENCIES_SHOW } from '../constants';

export default function reducer(state = {}, { type, payload }) {
  switch (type) {
    case CURRENCIES_SHOW:
      return payload;

    default:
      return state;
  }
}
