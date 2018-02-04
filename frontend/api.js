import { history } from 'store';

export function request(url, data, type = 'GET', headerOptions = {}) {
  const headers = {
    Mode: 'cors',
    Charset: 'utf-8',
    'X-Requested-With': 'XMLHttpRequest',
    ...headerOptions
  };

  const token = localStorage.getItem('X-CSRF-Token');

  if (token) headers['X-CSRF-Token'] = token;

  return fetch(url, {
    method: type,
    headers,
    credentials: 'same-origin',
    body: data
  })
    .then((response) => {
      switch (response.status) {
        case 401:
        case 403: {
          if (token) localStorage.removeItem('X-CSRF-Token');
          history.push('/login');
          throw response;
        }

        default: {
          const newToken = response.headers.get('X-CSRF-Token');
          if (newToken) {
            localStorage.setItem('X-CSRF-Token', token);
          }
        }
      }

      return response;
    });
}

export function JSONRequest(url, data, type = 'POST', headerOptions = {}) {
  return request(
    url,
    JSON.stringify(data),
    type,
    { 'Content-Type': 'application/json', ...headerOptions },
  )
    .then(response => response.json());
}
