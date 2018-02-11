import { TRADE_CREATE, TRADES_INDEX } from '../constants';

export default function reducer(state = [], { type, payload }) {
  switch (type) {
    case TRADE_CREATE:
      return [...state, payload];

    case TRADES_INDEX:
      return payload;

    default:
      return state;
  }
}
