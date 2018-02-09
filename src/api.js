import { history } from 'store';

import store from 'index';
import { showAlert } from 'modules/alerts';

export function request(url, data, type = 'GET', headerOptions = {}) {
  const headers = {
    Mode: 'cors',
    Charset: 'utf-8',
    'X-Requested-With': 'XMLHttpRequest',
    ...headerOptions,
  };

  const token = localStorage.getItem('X-CSRF-Token');
  if (token) headers['X-CSRF-Token'] = token;

  return fetch(url, {
    method: type,
    headers,
    credentials: 'same-origin',
    body: data,
  })
    .then((response) => {
      switch (response.status) {
        case 401:
        case 403: {
          if (token) localStorage.removeItem('X-CSRF-Token');
          history.push('/login');
          break;
        }

        case 500:
          history.push('/500');
          break;

        default: {
          const newToken = response.headers.get('X-CSRF-Token');
          if (newToken) {
            localStorage.setItem('X-CSRF-Token', newToken);
          }
        }
      }

      if (!response.ok) throw response;

      return response;
    })
    .catch(error => error.json()
      .then(json => store.dispatch(
        showAlert(json.message),
      )));
}

export function JSONRequest(url, data, type = 'POST', headerOptions = {}) {
  return request(
    url,
    JSON.stringify(data),
    type,
    { 'Content-Type': 'application/json', ...headerOptions },
  );
}

/*
function objectToParams(object) {
  if (!object || typeof object !== 'object') return '';
  return Object.entries(object).reduce((str, [key, value], index) => {
    let result;
    if (Array.isArray(value)) {
      result = `${key}[]=` + value.join(`&${key}[]=`);
    } else if (typeof value === 'object') {
      result = Object
        .keys(value)
        .map(nestedKey => `${key}[${nestedKey}]=${value[nestedKey]}`)
        .join('&');
    } else {
      result = `${key}=${value}`;
    }
    if (index === 0) return `${str}?${result}`;
    return `${str}&${result}`;
  }, '');
}
*/
