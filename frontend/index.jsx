import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';

import 'typeface-roboto';

import configureStore, { history } from 'store';

import Routes from 'routes';

import 'styles.css';

export const store = configureStore();

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Routes />
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root'),
);
