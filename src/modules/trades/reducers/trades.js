import { TRADE_CREATE } from '../constants';

export default function reducer(state = [], { type, payload }) {
  switch (type) {
    case TRADE_CREATE:
      return [...state, payload];

    default:
      return state;
  }
}
