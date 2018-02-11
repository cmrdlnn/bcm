import React, { Component, Fragment } from 'react';
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

import { fetchOrderBook } from 'modules/statistic';

import Form from 'components/Form';
import Field from 'components/Field';

import OrderList from '../components/OrderList';
import InfoRow from '../components/InfoRow';

class TradeCreation extends Component {
  componentWillMount() {
    this.props.fetchOrderBook();
  }

  render() {
    const { ask, ask_top: askTop, balances, bid, bid_top: bidTop } = this.props;

    return (
      <Fragment>
        <Col xs="4">
          <Card>
            <CardHeader>
              <i className="fa fa-balance-scale" />
              Создание торгов
            </CardHeader>
            <CardBody>
              <Form onSubmit={(e) => console.log(e)} buttonText="Создать">
                <Field
                  addon={<i className="fa fa-dollar" />}
                  helper="Цена в долларах за криптовалюту, по достижении которой система её купит"
                  name="start_course"
                  placeholder="Введите старт-курс"
                  required
                  title="Старт-курс"
                  type="number"
                />
                <Field
                  addon={<i className="fa fa-percent" />}
                  helper="Процент от падения/роста при котором система будет покупать/продавать криптовалюту"
                  name="margin"
                  placeholder="Введите маржу"
                  required
                  title="Маржа"
                  type="number"
                />
                <Field
                  addon={<i className="fa fa-dollar" />}
                  helper="Количество долларов на счету, которые войдут в оборот торгов"
                  name="order_price"
                  placeholder="Введите оборот"
                  required
                  title="Оборот"
                  type="number"
                />
              </Form>
            </CardBody>
          </Card>
        </Col>
        <Col xs="8">
          <Row className="mb-3">
            <Card>
              <CardHeader>
                <i className="icon-graph" />
                Последние цены
              </CardHeader>
              <CardBody>
                <InfoRow title="Баланс долларов на счету" value={balances && balances.BTC} />
                <hr />
                <InfoRow title="Баланс биткоинов на счету" value={balances && balances.USD} />
                <hr />
                <InfoRow helper="Долларов за bitcoin" title="Минимальная цена продажи" value={askTop} />
                <hr />
                <InfoRow helper="Долларов за bitcoin" title="Максимальная цена покупки" value={bidTop} />
              </CardBody>
            </Card>
          </Row>
          <Row>
            <Col xs={6}>
              <OrderList list={ask} title="Cписок текущих ордеров на продажу" />
            </Col>
            <Col xs={6}>
              <OrderList list={bid} title="Cписок текущих ордеров на покупку" />
            </Col>
          </Row>
        </Col>
      </Fragment>
    );
  }
}

const mapStateToProps = ({
  statistic: { order_book },
  user: { balances },
}) => ({
  ...order_book,
  balances,
});

const mapDispatchToProps = dispatch => ({
  fetchOrderBook: bindActionCreators(fetchOrderBook, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(TradeCreation);
