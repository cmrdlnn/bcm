import React, { Component } from 'react';
import PropTypes from 'prop-types';

import IconButton from 'material-ui/IconButton';
import AccountCircle from 'material-ui-icons/AccountCircle';
import Menu, { MenuItem } from 'material-ui/Menu';

class HeaderToolbar extends Component {
  constructor(props) {
    super(props);
    this.state = { anchorEl: null };
  }

  handleMenu = (e) => {
    this.setState({ anchorEl: e.currentTarget });
  }

  handleClose = () => {
    this.setState({ anchorEl: null });
  }

  render() {
    const { anchorEl } = this.state;
    const open = Boolean(anchorEl);

    return (
      <div>
        <IconButton
          aria-owns={open ? 'menu-appbar' : null}
          aria-haspopup="true"
          onClick={this.handleMenu}
          color="inherit"
        >
          <AccountCircle />
        </IconButton>
        <Menu
          id="menu-appbar"
          anchorEl={anchorEl}
          anchorOrigin={{
            vertical: 'top',
            horizontal: 'right'
          }}
          transformOrigin={{
            vertical: 'top',
            horizontal: 'right'
          }}
          open={open}
          onClose={this.handleClose}
        >
          {
            this.props.items.map((item, i) => (
              <MenuItem key={`MenuItem-${i}`} onClick={item.onClick}>{item.title}</MenuItem>
            ))
          }
        </Menu>
      </div>
    );
  }
}

HeaderToolbar.propTypes = {
  items: PropTypes.arrayOf(
    PropTypes.shape({
      title: PropTypes.string.isRequired,
      onClick: PropTypes.func.isRequired
    })
  ).isRequired
};

export default HeaderToolbar;
