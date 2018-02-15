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

import { changeEmail, changePassword } from 'modules/user';
import { showAlert } from 'modules/alerts';

import ConfirmModal from 'components/ConfirmModal';
import Form from 'components/Form';
import Field from 'components/Field';

class Settings extends Component {
  constructor(props) {
    super(props);
    this.state = {
      modalBody: null,
      modalHeader: null,
      modalIsOpen: false,
      onConfirm: null,
    };
  }

  toggle = () => this.setState({ modalIsOpen: !this.state.modalIsOpen })

  changeEmail = (data) => {
    this.setState({
      modalBody: 'На новый e-mail придёт письмо с инструкцией',
      modalHeader: 'Вы действительно хотите изменить свой e-mail?',
      modalIsOpen: true,
      onConfirm: () => {
        this.toggle();
        this.props.changeEmail(data);
      },
    });
  }

  changePassword = (data) => {
    const { showAlert, changePassword } = this.props;

    if (data.new_password !== data.confirm_password) {
      this.toggle();
      showAlert('Пароли не совпадают');
      return;
    }

    if (data.new_password.length < 6) {
      this.toggle();
      showAlert('Новый пароль слишком короткий');
      return;
    }

    this.setState({
      modalBody: null,
      modalHeader: 'Вы действительно хотите изменить свой пароль?',
      modalIsOpen: true,
      onConfirm: () => {
        this.toggle();
        this.props.changePassword(data);
      },
    });
  }

  render() {
    const {
      modalBody,
      modalHeader,
      modalIsOpen,
      onConfirm,
    } = this.state;

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
                { this.props.role !== 'trader' ? null : (
                  <Form onSubmit={this.changeEmail} buttonText="Изменить">
                    <h4>E-Mail</h4>
                    <Field
                      addon="@"
                      name="new_email"
                      placeholder="Введите новый e-mail"
                      required
                      type="email"
                    />
                  </Form>
                )}
                <Form onSubmit={this.changePassword} buttonText="Изменить">
                  <h4>Пароль</h4>
                  <Field
                    addon={<i className="icon-lock" />}
                    name="old_password"
                    placeholder="Введите старый пароль"
                    required
                    title="Старый пароль"
                    type="password"
                  />
                  <Field
                    addon={<i className="icon-lock" />}
                    name="new_password"
                    placeholder="Введите новый пароль"
                    required
                    title="Новый пароль"
                    type="password"
                  />
                  <Field
                    addon={<i className="icon-lock" />}
                    name="confirm_password"
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
        <ConfirmModal
          body={modalBody}
          header={modalHeader}
          isOpen={modalIsOpen}
          onConfirm={onConfirm}
          onReject={this.toggle}
        />
      </div>
    );
  }
}

Settings.propTypes = {
  showAlert: PropTypes.func.isRequired,
  changeEmail: PropTypes.func.isRequired,
  changePassword: PropTypes.func.isRequired,
};

const mapStateToProps = ({ user: { role } }) => ({ role });

const mapDispatchToProps = dispatch => ({
  showAlert: bindActionCreators(showAlert, dispatch),
  changeEmail: bindActionCreators(changeEmail, dispatch),
  changePassword: bindActionCreators(changePassword, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Settings);
