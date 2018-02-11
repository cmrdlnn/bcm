import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Button,
  Card,
  CardBody,
  CardHeader,
  Col,
  FormGroup,
  FormText,
  Input,
  InputGroup,
  InputGroupAddon,
  Label,
  Row,
} from 'reactstrap';

import { createUser } from 'modules/administration';

class UserCreation extends Component {
  handelSubmit = (e) => {
    e.preventDefault();
    this.props.createUser({ login: e.target.elements.login.value });
  }

  render() {
    return (
      <div className="animated fadeIn">
        <Row>
          <Col xs="12">
            <Card>
              <CardHeader>
                <i className="fa fa-edit" />
                Создание нового пользователя
              </CardHeader>
              <CardBody>
                <form onSubmit={this.handelSubmit}>
                  <FormGroup>
                    <Label for="login">e-mail</Label>
                    <InputGroup>
                      <InputGroupAddon addonType="prepend">@</InputGroupAddon>
                      <Input
                        id="login"
                        name="login"
                        placeholder="Введите e-mail нового пользователя"
                        required
                        type="email"
                      />
                    </InputGroup>
                    <FormText>
                      Новому пользователю автоматически будет выслано письмо с паролем
                    </FormText>
                  </FormGroup>
                  <Button type="submit" color="primary">Создать</Button>
                </form>
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

UserCreation.propTypes = { createUser: PropTypes.func.isRequired };

const mapDispatchToProps = dispatch => ({ createUser: bindActionCreators(createUser, dispatch) });

export default connect(null, mapDispatchToProps)(UserCreation);
