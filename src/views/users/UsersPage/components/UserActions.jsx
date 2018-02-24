import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  ButtonDropdown,
  DropdownItem,
  DropdownMenu,
  DropdownToggle,
} from 'reactstrap';

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
    const { id, login, onDeleteUser } = this.props;

    return (
      <ButtonDropdown isOpen={isOpen} toggle={this.toggle}>
        <DropdownToggle caret className="p-0" color="link">
          <i className="icon-settings" />
        </DropdownToggle>
        <DropdownMenu className={isOpen ? 'show' : ''} right>
          <DropdownItem onClick={() => onDeleteUser(id, login)}>Удалить</DropdownItem>
        </DropdownMenu>
      </ButtonDropdown>
    );
  }
}

UserActions.propTypes = {
  id: PropTypes.number.isRequired,
  login: PropTypes.string.isRequired,
  onDeleteUser: PropTypes.func.isRequired,
};

export default UserActions;
