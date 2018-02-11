import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  Card,
  CardBody,
  CardHeader,
  Col,
  Row,
} from 'reactstrap';

import Form from 'components/Form';
import Field from 'components/Field';

class Settings extends Component {
  render() {
    return (
      <div className="animated fadeIn">
        <Row>
          <Col xs="12">
            <Card>
              <CardHeader>
                <i className="fa fa-edit" />
                Изменение данных аккаунта
              </CardHeader>
              <CardBody>
                <Form onSubmit={(e) => console.log(e)} buttonText="Изменить">
                  <Field
                    addon="@"
                    name="login"
                    placeholder="Введите новый e-mail"
                    required
                    title="email"
                    type="email"
                  />
                </Form>
                <Form onSubmit={(e) => console.log(e)} buttonText="Изменить">
                  <Field
                    addon={<i className="icon-lock" />}
                    name="password"
                    placeholder="Введите новый пароль"
                    required
                    title="Новый пароль"
                    type="password"
                  />
                  <Field
                    addon={<i className="icon-lock" />}
                    name="confirm-password"
                    placeholder="Повторите новый пароль"
                    required
                    title="Повторите пароль"
                    type="password"
                  />
                </Form>
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

export default Settings;
