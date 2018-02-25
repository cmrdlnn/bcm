import { TRADE_CLEAR, TRADE_CREATE, TRADE_FETCH, TRADES_INDEX, TRADE_UPDATE } from '../constants';

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

    case TRADE_UPDATE: {
      const index = state.all.findIndex(trade => trade.id === payload.id);
      const current = state.current ? { current: [{ ...state.current[0], ...payload }, state.current[1]] } : {};
      return { ...state, all: [...state.all.slice(0, index), payload, ...state.all.slice(index + 1)], ...current };
    }

    default:
      return state;
  }
}
