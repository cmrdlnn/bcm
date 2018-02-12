import React, { Fragment } from 'react';
import PropTypes from 'prop-types';
import {
  // Pagination,
  // PaginationItem,
  // PaginationLink,
  Table,
} from 'reactstrap';

import UserActions from './UserActions';

const UsersTable = ({ users }) => (
  <Fragment>
    <Table hover bordered striped size="sm">
      <thead>
        <tr>
          <th>Электронная почта</th>
          <th>Дата регистрации</th>
          <th>Роль</th>
          <th>Действия</th>
        </tr>
      </thead>
      <tbody>
        {
          users.map(user => (
            <tr key={user.id}>
              <td>{ user.login }</td>
              <td>{ new Date(user.created_at).toLocaleString('ru') }</td>
              <td>Трейдер</td>
              <td><UserActions id={user.id} /></td>
            </tr>
          ))
        }
      </tbody>
    </Table>
    { /*
    <nav>
      <Pagination>
        <PaginationItem><PaginationLink previous href="#">Назад</PaginationLink></PaginationItem>
        <PaginationItem active>
          <PaginationLink href="#">1</PaginationLink>
        </PaginationItem>
        <PaginationItem><PaginationLink href="#">2</PaginationLink></PaginationItem>
        <PaginationItem><PaginationLink href="#">3</PaginationLink></PaginationItem>
        <PaginationItem><PaginationLink href="#">4</PaginationLink></PaginationItem>
        <PaginationItem><PaginationLink next href="#">Далее</PaginationLink></PaginationItem>
      </Pagination>
    </nav>
    */ }
  </Fragment>
);

UsersTable.defaultProps = { users: [] };

UsersTable.propTypes = {
  users: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      login: PropTypes.string.isRequired,
    }),
  ),
};

export default UsersTable;
