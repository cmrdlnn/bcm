import React, { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';

import 'bootstrap/dist/css/bootstrap.css';
import 'simple-line-icons/css/simple-line-icons.css';
import 'font-awesome/css/font-awesome.min.css';
import './scss/style.scss';

import configureStore, { history } from './store';

import Notifier from './components/Notifier';

import Routes from './routes/index';

const store = configureStore();

ReactDOM.render((
  <Provider store={store}>
    <Fragment>
      <Notifier />
      <ConnectedRouter history={history}>
        <Routes />
      </ConnectedRouter>
    </Fragment>
  </Provider>
), document.getElementById('root'));

export default store;
