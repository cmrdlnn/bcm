import React from 'react';
import { Col, Container, Row } from 'reactstrap';

const Page500 = () => (
  <div className="app flex-row align-items-center">
    <Container>
      <Row className="justify-content-center">
        <Col md="6">
          <span className="clearfix">
            <h1 className="float-left display-3 mr-4">500</h1>
            <h4 className="pt-3">Хьюстон, у нас проблемы!</h4>
            <p className="text-muted float-left">Произошла ошибка. Страница в данный момент недоступна.</p>
          </span>
          { /*
            <InputGroup className="input-prepend">
              <InputGroupAddon><i className="fa fa-search"></i></InputGroupAddon>
              <Input size="16" type="text" placeholder="What are you looking for?" />
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

export default Page500;
