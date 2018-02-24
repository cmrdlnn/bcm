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

import { deleteUser, indexUsers } from 'modules/administration';

import ConfirmModal from 'components/ConfirmModal';

import UsersTable from './components/UsersTable';

const onDeleteUserMessage = 'Внимание! После удаления пользователя все его торги, будь они ' +
      'закрытыми или активными, будут удалены, а текущие открытые ордера, если таковые имеются, ' +
      'отозваны.';

class UsersPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      idOfBeingDeletedUser: null,
      modalHeader: null,
      modalIsOpen: false,
    };
  }

  componentWillMount() {
    this.props.indexUsers();
  }

  handleDeleteUser = (id, login) => {
    this.setState({
      idOfBeingDeletedUser: id,
      modalHeader: `Вы действительно хотите удалить пользователя ${login}?`,
      modalIsOpen: true,
    });
  }

  nullifyState = () => {
    this.setState({
      idOfBeingDeletedUser: null,
      modalHeader: null,
      modalIsOpen: false,
    });
  }

  handleConfirm = () => {
    this.props.deleteUser(this.state.idOfBeingDeletedUser);
    this.nullifyState();
  }

  render() {
    const { users } = this.props;
    const { modalHeader, modalIsOpen } = this.state;

    return (
      <div className="animated fadeIn">
        <ConfirmModal
          body={onDeleteUserMessage}
          header={modalHeader}
          isOpen={modalIsOpen}
          onConfirm={this.handleConfirm}
          onReject={this.nullifyState}
        />
        <Row>
          <Col>
            <Card>
              <CardHeader>
                <i className="fa fa-align-justify" />
                Список пользователей
              </CardHeader>
              <CardBody>
                { users.length ? (
                  <UsersTable onDeleteUser={this.handleDeleteUser} users={users} />
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
  deleteUser: PropTypes.func.isRequired,
  indexUsers: PropTypes.func.isRequired,
  users: PropTypes.arrayOf(PropTypes.object),
};

const mapStateToProps = ({ administration: { users } }) => ({ users });

const mapDispatchToProps = dispatch => ({
  deleteUser: bindActionCreators(deleteUser, dispatch),
  indexUsers: bindActionCreators(indexUsers, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(UsersPage);
