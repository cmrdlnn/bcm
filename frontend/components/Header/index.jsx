import React from 'react';

import { withStyles } from 'material-ui/styles';
import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import Typography from 'material-ui/Typography';

import Logo from './components/Logo';

import './styles.css';

const styles = { flex: { flex: 1 } };

const Header = ({ children, classes }) => (
  <AppBar className="header" position="static">
    <Toolbar>
      <Logo />
      <Typography className={classes.flex} type="title" color="inherit">
        itcoin Course Monitoring
      </Typography>
      { children }
    </Toolbar>
  </AppBar>
);

export default withStyles(styles)(Header);
