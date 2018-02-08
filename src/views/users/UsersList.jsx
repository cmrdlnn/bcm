import React, { Component } from 'react';
import {
  Row,
  Col,
  Card,
  CardHeader,
  CardBlock,
  Table,
  Pagination,
  PaginationItem,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  ButtonDropdown,
  PaginationLink
} from 'reactstrap';

class UsersList extends Component {
  constructor(props) {
    super(props);

    this.toggle = this.toggle.bind(this);
    this.state = {
      dropdownOpen: false
    };
  }

  toggle() {
    this.setState({
      dropdownOpen: !this.state.dropdownOpen
    });
  }
  render() {
    return (
      <div className="animated fadeIn">
        <Row>
          <Col>
            <Card>
              <CardHeader>
                <i className="fa fa-align-justify"></i>
                Список пользователей
              </CardHeader>
              <CardBlock className="card-body">
                <Table hover bordered striped responsive size="sm">
                  <thead>
                    <tr>
                      <th>Электронная почта</th>
                      <th>Дата  регистрации</th>
                      <th>Роль</th>
                      <th>Действия</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>test@test.test</td>
                      <td>08.02.2018</td>
                      <td>Staff</td>
                      <td>
                        <ButtonDropdown isOpen={this.state.card1}
                                        toggle={() => { this.setState({ card1: !this.state.card1 }); }}>
                          <DropdownToggle caret className="p-0" color="link">
                            <i className="icon-settings" />
                          </DropdownToggle>
                          <DropdownMenu className={this.state.card1 ? 'show' : ''} right>
                            <DropdownItem>Изменить e-mail</DropdownItem>
                            <DropdownItem>Удалить</DropdownItem>
                          </DropdownMenu>
                        </ButtonDropdown>
                      </td>
                    </tr>
                  </tbody>
                </Table>
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
              </CardBlock>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

export default UsersList;
