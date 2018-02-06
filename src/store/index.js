import { createStore, combineReducers, applyMiddleware } from 'redux';
import { routerMiddleware, routerReducer } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';
import thunk from 'redux-thunk';
import { createLogger } from 'redux-logger';

import rootReducer from 'modules';

export const history = createHistory();

export default function configureStore(initialState) {
  const middleware = [thunk, routerMiddleware(history)];

  if (process.env.NODE_ENV !== 'production') {
    middleware.push(createLogger());
  }

  return createStore(
    combineReducers({ ...rootReducer, router: routerReducer }),
    initialState,
    applyMiddleware(...middleware),
  );
}
