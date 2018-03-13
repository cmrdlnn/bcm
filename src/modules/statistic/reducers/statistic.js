import { FETCH_ORDER_BOOK, FETCH_PAIR_SETTINGS, FETCH_TICKER } from '../constants';

export default function reducer(
  state = { orderBook: {}, pairSettings: {}, ticker: {} }, { type, payload },
) {
  switch (type) {
    case FETCH_ORDER_BOOK:
      return { ...state, orderBook: payload };

    case FETCH_PAIR_SETTINGS:
      return { ...state, pairSettings: payload };

    case FETCH_TICKER:
      return { ...state, ticker: payload };

    default:
      return state;
  }
}
