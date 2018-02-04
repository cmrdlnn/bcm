import { history } from 'store';
import { store } from 'index';

import { logout } from 'modules/user';

import TradesPage from './containers/TradesPage';

const route = {
  path: '/trades',
  main: TradesPage,
  header: [
    {
      title: 'Архив торгов',
      onClick: () => history.push('/archive')
    },
    {
      title: 'Настройки профиля',
      onClick: () => history.push('/profile')
    },
    {
      title: 'Выйти',
      onClick: () => store.dispatch(logout())
    }
  ]
};

export default route;
