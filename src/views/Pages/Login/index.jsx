import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Button,
  Card,
  CardBody,
  CardGroup,
  Col,
  Container,
  Row,
} from 'reactstrap';

import { signIn } from 'modules/user';

import Field from 'components/Field';
import Form from 'components/Form';

const Login = ({ signIn }) => (
  <div className="app flex-row align-items-center">
    <Container>
      <Row className="justify-content-center">
        <Col md="6">
          <CardGroup className="mb-0">
            <Card className="p-4">
              <CardBody>
                <h1>Вход</h1>
                <p className="text-muted">Аутентифицируйтесь в системе</p>
                <Form onSubmit={signIn} withoutButton withoutReset>
                  <Field
                    addon={<i className="icon-user" />}
                    className="mb-3"
                    name="login"
                    placeholder="Имя пользователя"
                    required
                  />
                  <Field
                    addon={<i className="icon-lock" />}
                    className="mb-4"
                    name="password"
                    placeholder="Пароль"
                    required
                    type="password"
                  />
                  <Row>
                    <Col xs="6">
                      <Button color="primary" className="px-4" type="submit">Войти</Button>
                    </Col>
                    <Col xs="6" className="text-right">
                      <Button color="link" className="px-0">Забыли пароль?</Button>
                    </Col>
                  </Row>
                </Form>
              </CardBody>
            </Card>
            { /*
              <Card className="text-white bg-primary py-5 d-md-down-none" style={{ width: 44 + '%' }}>
                <CardBody className="text-center">
                  <div>
                    <h2>Sign up</h2>
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut
                      labore et dolore magna aliqua.</p>
                    <Button color="primary" className="mt-3" active>Register Now!</Button>
                  </div>
                </CardBody>
              </Card>
            */ }
          </CardGroup>
        </Col>
      </Row>
    </Container>
  </div>
)

Login.propTypes = { signIn: PropTypes.func.isRequired };

const mapDispatchToProps = dispatch => ({ signIn: bindActionCreators(signIn, dispatch) });

export default connect(null, mapDispatchToProps)(Login);
