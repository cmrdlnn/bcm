import React from 'react';
import PropTypes from 'prop-types';

import { Card, CardBody, CardHeader, Table } from 'reactstrap';

const OrderList = ({ list, title }) => (
  <Card>
    <CardHeader>
      <i className="icon-list" />
      { title }
    </CardHeader>
    <CardBody>
      <Table hover responsive size="sm">
        <thead>
          <tr>
            <th>Цена</th>
            <th>Количество</th>
          </tr>
        </thead>
        <tbody>
          {
            list && list.map((values, i) => (
              <tr key={i}>
                <td>{ values[0] }</td>
                <td>{ values[1] }</td>
              </tr>
            ))
          }
        </tbody>
      </Table>
    </CardBody>
  </Card>
);

OrderList.defaultProps = { list: null };

OrderList.propTypes = {
  title: PropTypes.string.isRequired,
  list: PropTypes.arrayOf(
    PropTypes.arrayOf(
      PropTypes.string,
    ),
  ),
};

export default OrderList;
