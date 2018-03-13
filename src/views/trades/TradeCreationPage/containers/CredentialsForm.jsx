import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Card,
  CardBody,
  CardHeader,
  Col,
} from 'reactstrap';

import { fetchInfo } from 'modules/user';

import Form from 'components/Form';
import Field from 'components/Field';

const CredentialsForm = ({ infoFetch }) => (
  <Col xs="12">
    <Card>
      <CardHeader>
        <i className="fa fa-balance-scale" />
        Создание торгов
      </CardHeader>
      <CardBody>
        <Form
          buttonText="Далее"
          onSubmit={formData => infoFetch(formData)}
        >
          <Field
            addon={<i className="icon-key" />}
            name="key"
            placeholder="Введите публичный ключ"
            required
            title="Публичный ключ"
          />
          <Field
            addon={<i className="icon-lock" />}
            name="secret"
            placeholder="Введите секретный ключ"
            required
            title="Секретный ключ"
          />
        </Form>
      </CardBody>
    </Card>
  </Col>
);

CredentialsForm.propTypes = { infoFetch: PropTypes.func.isRequired };

const mapDispatchToProps = dispatch => ({ infoFetch: bindActionCreators(fetchInfo, dispatch) });

export default connect(null, mapDispatchToProps)(CredentialsForm);
