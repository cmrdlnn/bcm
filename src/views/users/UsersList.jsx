import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Button,
  ButtonDropdown,
  Card,
  CardBody,
  CardHeader,
  Col,
  DropdownItem,
  DropdownMenu,
  DropdownToggle,
  Pagination,
  PaginationItem,
  PaginationLink,
  Row,
  Table,
} from 'reactstrap';

import { history } from 'store';

import { indexUsers } from 'modules/administration';

import Spinner from 'components/Spinner';

class UsersActions extends Component {
  constructor(props) {
    super(props);
    this.state = { isOpen: false };
  }

  toggle = () => {
    this.setState({ isOpen: !this.state.isOpen });
  }

  render() {
    const { isOpen } = this.state;

    return (
      <ButtonDropdown isOpen={isOpen} toggle={this.toggle}>
        <DropdownToggle caret className="p-0" color="link">
          <i className="icon-settings" />
        </DropdownToggle>
        <DropdownMenu className={isOpen ? 'show' : ''} right>
          <DropdownItem>Изменить e-mail</DropdownItem>
          <DropdownItem>Удалить</DropdownItem>
        </DropdownMenu>
      </ButtonDropdown>
    );
  }
}


const UsersTable = ({ users }) => (
  <Fragment>
    <Table hover bordered striped responsive size="sm">
      <thead>
        <tr>
          <th>Электронная почта</th>
          <th>Дата регистрации</th>
          <th>Роль</th>
          <th>Действия</th>
        </tr>
      </thead>
      <tbody>
        {
          users.map(user => (
            <tr key={user.id}>
              <td>{ user.login }</td>
              <td>{ new Date(user.created_at).toLocaleString('ru') }</td>
              <td>Трейдер</td>
              <td><UsersActions /></td>
            </tr>
          ))
        }
      </tbody>
    </Table>
    { /*
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
    */ }
  </Fragment>
)

class Users extends Component {
  componentWillMount() {
    this.props.indexUsers();
  }

  render() {
    const { fetching, users } = this.props;

    return (
      <div className="animated fadeIn">
        <Row>
          <Col>
            <Card>
              <CardHeader>
                <i className="fa fa-align-justify"></i>
                Список пользователей
              </CardHeader>
              <CardBody>
                {
                  fetching ? (
                    <Spinner />
                  ) : (
                    users.length ? (
                      <UsersTable users={users} />
                    ) : (
                      <Fragment>
                        <h2 className="text-center">В системе нет зарегистрированых пользователей</h2>
                        <Button
                          color="primary"
                          onClick={() => history.push('/users/create')}
                        >
                          Создать первого пользователя
                        </Button>
                      </Fragment>
                    )
                  )
                }
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

Users.propTypes = {
  indexUsers: PropTypes.func.isRequired,
  fetching: PropTypes.bool.isRequired,
};

const mapStateToProps = ({ administration: { fetching, users } }) => ({ fetching, users });

const mapDispatchToProps = dispatch => ({ indexUsers: bindActionCreators(indexUsers, dispatch) });

export default connect(mapStateToProps, mapDispatchToProps)(Users);
