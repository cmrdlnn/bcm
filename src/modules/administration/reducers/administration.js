import { CREATE, DELETE, INDEX } from '../constants';

export default function reducer(state = { fetching: true, users: [] }, { type, payload }) {
  switch (type) {
    case CREATE:
      return { ...state, users: [...state.users, payload] };

    case DELETE:
      return { ...state, users: state.users.filter(user => user !== payload) };

    case INDEX:
      return { users: payload };

    default:
      return state;
  }
}
