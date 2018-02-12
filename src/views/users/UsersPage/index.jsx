import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Button,
  Card,
  CardBody,
  CardHeader,
  Col,
  Row,
} from 'reactstrap';

import { history } from 'store';

import { indexUsers } from 'modules/administration';

import UsersTable from './components/UsersTable';

class UsersPage extends Component {
  componentWillMount() {
    this.props.indexUsers();
  }

  render() {
    return (
      <div className="animated fadeIn">
        <Row>
          <Col>
            <Card>
              <CardHeader>
                <i className="fa fa-align-justify" />
                Список пользователей
              </CardHeader>
              <CardBody>
                { this.props.users.length ? (
                  <UsersTable users={this.props.users} />
                ) : (
                  <Fragment>
                    <h2 className="text-center mb-3">В системе нет зарегистрированых пользователей</h2>
                    <Button
                      block
                      color="primary"
                      onClick={() => history.push('/users/create')}
                      outline
                    >
                      Создать первого пользователя
                    </Button>
                  </Fragment>
                )}
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

UsersPage.defaultProps = { users: [] };

UsersPage.propTypes = {
  indexUsers: PropTypes.func.isRequired,
  users: PropTypes.arrayOf(PropTypes.object),
};

const mapStateToProps = ({ administration: { users } }) => ({ users });

const mapDispatchToProps = dispatch => ({ indexUsers: bindActionCreators(indexUsers, dispatch) });

export default connect(mapStateToProps, mapDispatchToProps)(UsersPage);
