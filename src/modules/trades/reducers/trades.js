import { TRADE_CLEAR, TRADE_CREATE, TRADE_FETCH, TRADES_INDEX } from '../constants';

export default function reducer(state = { all: [] }, { type, payload }) {
  switch (type) {
    case TRADE_CLEAR:
      return { all: state.all };

    case TRADE_CREATE:
      return { ...state, all: [...state.all, payload] };

    case TRADE_FETCH:
      return { ...state, current: payload };

    case TRADES_INDEX:
      return { ...state, all: payload };

    default:
      return state;
  }
}
