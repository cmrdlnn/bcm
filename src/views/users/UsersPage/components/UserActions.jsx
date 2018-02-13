import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  ButtonDropdown,
  DropdownItem,
  DropdownMenu,
  DropdownToggle,
} from 'reactstrap';

import { deleteUser } from 'modules/administration';

class UserActions extends Component {
  constructor(props) {
    super(props);
    this.state = { isOpen: false };
  }

  toggle = () => {
    this.setState({ isOpen: !this.state.isOpen });
  }

  render() {
    const { isOpen } = this.state;
    const { id, deleteUser, updateEmail } = this.props;

    return (
      <ButtonDropdown isOpen={isOpen} toggle={this.toggle}>
        <DropdownToggle caret className="p-0" color="link">
          <i className="icon-settings" />
        </DropdownToggle>
        <DropdownMenu className={isOpen ? 'show' : ''} right>
          <DropdownItem>Изменить e-mail</DropdownItem>
          <DropdownItem onClick={() => deleteUser(id)}>Удалить</DropdownItem>
        </DropdownMenu>
      </ButtonDropdown>
    );
  }
}

const mapDispatchToProps = dispatch => ({ deleteUser: bindActionCreators(deleteUser, dispatch) });

export default connect(null, mapDispatchToProps)(UserActions);
