import React, { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { Route, Switch } from 'react-router-dom';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';

import 'bootstrap/dist/css/bootstrap.css';
import 'font-awesome/css/font-awesome.min.css';
import 'simple-line-icons/css/simple-line-icons.css';
import './scss/style.scss';

import configureStore, { history } from './store';

import Login from './views/Pages/Login';
import Page404 from './views/Pages/Page404';
import Page500 from './views/Pages/Page500';
// import Register from './views/Pages/Register';

import Notifier from './components/Notifier';
import Full from './containers/Full';

const store = configureStore();

ReactDOM.render((
  <Provider store={store}>
    <Fragment>
      <Notifier />
      <ConnectedRouter history={history}>
        <Switch>
          <Route exact path="/login" name="Login Page" component={Login} />
          { /* <Route exact path="/register" name="Register Page" component={Register} /> */ }
          <Route exact path="/404" name="Page 404" component={Page404} />
          <Route exact path="/500" name="Page 500" component={Page500} />
          <Route path="/" name="Home" component={Full} />
        </Switch>
      </ConnectedRouter>
    </Fragment>
  </Provider>
), document.getElementById('root'));

export default store;
