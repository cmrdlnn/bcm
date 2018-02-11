import { FETCH_ORDER_BOOK, FETCH_TICKER } from '../constants';

export default function reducer(state = { ticker: {}, order_book: {} }, { type, payload }) {
  switch (type) {
    case FETCH_ORDER_BOOK:
      return { ...state, order_book: payload };

    case FETCH_TICKER:
      return { ...state, ticker: payload };

    default:
      return state;
  }
}
