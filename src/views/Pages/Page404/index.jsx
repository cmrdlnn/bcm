import React from 'react';
import { Col, Container, Row /* , Button, Input, InputGroupAddon, InputGroup, InputGroupButton */ } from 'reactstrap';

const Page404 = () => (
  <div className="app flex-row align-items-center">
    <Container>
      <Row className="justify-content-center">
        <Col md="6">
          <div className="clearfix">
            <h1 className="float-left display-3 mr-4">404</h1>
            <h4 className="pt-3">Упс! Вы потерялись.</h4>
            <p className="text-muted float-left">Страницы, которую Вы ищете, не существует.</p>
          </div>
          { /*
            <InputGroup className="input-prepend">
              <InputGroupAddon><i className="fa fa-search"></i></InputGroupAddon>
              <Input size="16" type="text" placeholder="What are you looking for?"/>
              <InputGroupButton>
                <Button color="info">Search</Button>
              </InputGroupButton>
            </InputGroup>
          */ }
        </Col>
      </Row>
    </Container>
  </div>
);

export default Page404;
