import React, { Component } from 'react';
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
  Row
} from 'reactstrap';

class UserCreation extends Component {
  constructor(props) {
    super(props);

    this.state = {};
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
                <form>
                  <FormGroup>
                    <Label for="email">e-mail</Label>
                    <InputGroup>
                      <InputGroupAddon addonType="prepend">@</InputGroupAddon>
                      <Input
                        id="email"
                        name="email"
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

export default UserCreation;
