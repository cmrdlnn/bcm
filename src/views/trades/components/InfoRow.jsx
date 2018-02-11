import React from 'react';
import PropTypes from 'prop-types';

import { Col, Row } from 'reactstrap';

const OrderList = ({ helper, title, value }) => (
  <Row>
    <Col xs="9" className="text-left">
      <div className="title">{title}</div>
      { helper && <small className="text-muted">{helper}</small> }
    </Col>
    <Col xs="3" className="text-right">
      <strong>{value}</strong>
    </Col>
  </Row>
);

OrderList.defaultProps = {
  helper: null,
  value: null,
};

OrderList.propTypes = {
  helper: PropTypes.string,
  title: PropTypes.string.isRequired,
  value: PropTypes.string,
};

export default OrderList;
