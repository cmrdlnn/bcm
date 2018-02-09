import { USER_CREATE, USER_UPDATE, USERS_INDEX } from '../constants';

export default function reducer(state = { users: [], fetching: true }, { type, payload }) {
  switch (type) {
    case USER_CREATE:
      return { ...state, users: [...state.users, payload] };

    case USER_UPDATE: {
      const index = state.users.findIndex(user => user.id === payload.id);
      return { ...state, users: [...state.users.slice(0, index), payload, ...state.users.slice(index + 1)] };
    }

    case USERS_INDEX:
      return { ...state, users: payload, fetching: false };

    default:
      return state;
  }
}
