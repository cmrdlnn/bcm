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
import { createTrade } from 'modules/trades';

import Field from 'components/Field';
import Form from 'components/Form';
import InfoRow from 'components/InfoRow';
import OrderList from 'components/OrderList';


class TradeCreation extends Component {
  componentWillMount() {
    const { fetchOrderBook } = this.props;
    fetchOrderBook();
    this.fetcher = setInterval(fetchOrderBook, 6000);
  }

  componentWillUnmount() {
    clearInterval(this.fetcher);
  }

  render() {
    const {
      ask,
      ask_top: askTop,
      balances,
      bid,
      bid_top: bidTop,
      tradeCreate,
    } = this.props;

    return (
      <Fragment>
        <Col xs="4">
          <Card>
            <CardHeader>
              <i className="fa fa-balance-scale" />
              Создание торгов
            </CardHeader>
            <CardBody>
              <Form onSubmit={data => tradeCreate(data)} buttonText="Создать">
                <Field
                  addon={<i className="fa fa-dollar" />}
                  helper="Цена в долларах за криптовалюту, опустившись ниже которой система её купит"
                  min={0}
                  name="start_course"
                  placeholder="Введите старт-курс"
                  required
                  title="Старт-курс"
                  type="number"
                />
                { /*
                <Field
                  addon={<i className="fa fa-percent" />}
                  helper="Процент от падения/роста при котором система будет покупать/продавать криптовалюту"
                  name="margin"
                  placeholder="Введите маржу"
                  required
                  step="0.1"
                  title="Маржа"
                  type="number"
                />
                */ }
                <Field
                  addon={<i className="fa fa-dollar" />}
                  helper="Количество долларов на счету, которые войдут в оборот торгов"
                  // max={balances && balances.USD}
                  min={Math.ceil(0.001 * askTop)}
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
                <InfoRow title="Баланс долларов на счету" value={balances && balances.USD} />
                <hr />
                <InfoRow title="Баланс биткоинов на счету" value={balances && balances.BTC} />
                <hr />
                <InfoRow
                  helper="Долларов за bitcoin среди текущих ордеров"
                  title="Минимальная цена продажи"
                  value={askTop}
                />
                <hr />
                <InfoRow
                  helper="Долларов за bitcoin среди текущих ордеров"
                  title="Максимальная цена покупки"
                  value={bidTop}
                />
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

const mapStateToProps = ({ statistic: { order_book } }) => ({ ...order_book });

const mapDispatchToProps = dispatch => ({
  fetchOrderBook: bindActionCreators(fetchOrderBook, dispatch),
  tradeCreate: bindActionCreators(createTrade, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(TradeCreation);
