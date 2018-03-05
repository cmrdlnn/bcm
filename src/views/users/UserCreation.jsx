import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Card,
  CardBody,
  CardHeader,
  Col,
  Row,
} from 'reactstrap';

import { createUser } from 'modules/administration';

import Field from 'components/Field';
import Form from 'components/Form';

const UserCreation = ({ userCreate }) => (
  <div className="animated fadeIn">
    <Row>
      <Col xs="12">
        <Card>
          <CardHeader>
            <i className="fa fa-edit" />
            Создание нового пользователя
          </CardHeader>
          <CardBody>
            <Form buttonText="Создать" onSubmit={userCreate}>
              <Field
                addon="@"
                helper="Новому пользователю автоматически будет выслано письмо с паролем"
                name="login"
                placeholder="Введите e-mail нового пользователя"
                required
                title="E-mail"
                type="email"
              />
            </Form>
          </CardBody>
        </Card>
      </Col>
    </Row>
  </div>
)

UserCreation.propTypes = { userCreate: PropTypes.func.isRequired };

const mapDispatchToProps = dispatch => ({ userCreate: bindActionCreators(createUser, dispatch) });

export default connect(null, mapDispatchToProps)(UserCreation);
