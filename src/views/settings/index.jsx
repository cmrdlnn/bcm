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
import Field from 'components/Field';
import Form from 'components/Form';

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
    const { alertShow, passwordChange } = this.props;

    if (data.new_password !== data.confirm_password) {
      this.toggle();
      alertShow('Пароли не совпадают');
      return;
    }

    if (data.new_password.length < 6) {
      this.toggle();
      alertShow('Новый пароль слишком короткий');
      return;
    }

    this.setState({
      modalBody: null,
      modalHeader: 'Вы действительно хотите изменить свой пароль?',
      modalIsOpen: true,
      onConfirm: () => {
        this.toggle();
        passwordChange(data);
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
                  <Form buttonText="Изменить" className="mb-4" onSubmit={this.changeEmail}>
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
                <Form buttonText="Изменить" onSubmit={this.changePassword}>
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
  changeEmail: PropTypes.func.isRequired,
  passwordChange: PropTypes.func.isRequired,
  role: PropTypes.string.isRequired,
  alertShow: PropTypes.func.isRequired,
};

const mapStateToProps = ({ user: { role } }) => ({ role });

const mapDispatchToProps = dispatch => ({
  alertShow: bindActionCreators(showAlert, dispatch),
  changeEmail: bindActionCreators(changeEmail, dispatch),
  passwordChange: bindActionCreators(changePassword, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Settings);
