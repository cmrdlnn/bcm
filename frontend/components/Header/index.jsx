import React from 'react';
import {
  Navbar,
  NavbarBrand,
  Container,
} from 'reactstrap';

import Logo from './components/Logo';

import './styles.css';

const Header = () => (
  <Navbar dark color="primary">
    <Container>
      <NavbarBrand href="#">
        <Logo />
        itcoin Course Monitoring
      </NavbarBrand>
    </Container>
  </Navbar>
);

export default Header;
