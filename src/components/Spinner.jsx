import React from 'react';
import { FadeLoader } from 'halogenium';
import { Container, Row } from 'reactstrap';

const Spinner = () => (
  <div className="app flex-row align-items-center">
    <Container>
      <Row className="justify-content-center">
        <FadeLoader color="#20a8d8" size="16px" margin="4px" />
      </Row>
    </Container>
  </div>
);

export default Spinner;
