import React from 'react';
import PropTypes from 'prop-types';

import { Col, Row } from 'reactstrap';

const IndoRow = ({ helper, title, value }) => (
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

IndoRow.defaultProps = {
  helper: null,
  value: null,
};

IndoRow.propTypes = {
  helper: PropTypes.string,
  title: PropTypes.string.isRequired,
  value: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.string,
  ]),
};

export default IndoRow;
