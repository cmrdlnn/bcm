import { history } from 'store';

import { LOGOUT } from '../constants';

export default function () {
  localStorage.removeItem('X-CSRF-Token');
  history.push('/login');
  return { type: LOGOUT };
}
