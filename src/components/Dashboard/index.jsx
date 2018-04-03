import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Row, Col } from 'reactstrap';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { fetchOrderBook, fetchTicker } from 'modules/statistic';

import OrderList from 'components/OrderList';
import TickerCard from './components/TickerCard';

class Dashboard extends Component {
  componentWillMount() {
    const { orderBookFetch, tickerFetch } = this.props;
    orderBookFetch('BTC_USD');
    this.orderBook = setInterval(() => orderBookFetch('BTC_USD'), 6000);
    tickerFetch();
    this.ticker = setInterval(tickerFetch, 6000);
  }

  componentWillUnmount() {
    clearInterval(this.orderBook);
    this.orderBook = null;
    clearInterval(this.ticker);
    this.ticker = null;
  }

  render() {
    const {
      avg,
      buy_price: buyPrice,
      high,
      last_trade: lastPrice,
      low,
      orderBook: {
        ask,
        bid,
      },
      sell_price: sellPrice,
    } = this.props;

    return (
      <div className="animated fadeIn">
        <Row className="mb-3">
          <Col sm="6" md="2">
            <TickerCard icon="icon-people" color="info" header="87.500" value={high}>
              максимальная цена сделки за 24 часа
            </TickerCard>
          </Col>
          <Col sm="6" md="2">
            <TickerCard icon="icon-user-follow" color="success" header="385" value={low}>
              минимальная цена сделки за 24 часа
            </TickerCard>
          </Col>
          <Col sm="6" md="2">
            <TickerCard icon="icon-basket-loaded" color="warning" header="1238" value={avg}>
              средняя цена сделки за 24 часа
            </TickerCard>
          </Col>
          <Col sm="6" md="2">
            <TickerCard icon="icon-pie-chart" color="primary" header="28%" value={lastPrice}>
              цена последней сделки
            </TickerCard>
          </Col>
          <Col sm="6" md="2">
            <TickerCard icon="icon-speedometer" color="danger" header="5:34:11" value={buyPrice}>
              текущая максимальная цена покупки
            </TickerCard>
          </Col>
          <Col sm="6" md="2">
            <TickerCard icon="icon-speech" color="info" header="972" value={sellPrice}>
              текущая минимальная цена продажи
            </TickerCard>
          </Col>
        </Row>
        <Row>
          <Col>
            <OrderList list={ask} title="Cписок текущих ордеров на продажу" />
          </Col>
          <Col>
            <OrderList list={bid} title="Cписок текущих ордеров на покупку" />
          </Col>
        </Row>
      </div>
    );
  }
}

Dashboard.defaultProps = {
  high: '0',
  low: '0',
  avg: '0',
  last_trade: '0',
  buy_price: '0',
  sell_price: '0',
};

Dashboard.propTypes = {
  avg: PropTypes.string,
  buy_price: PropTypes.string,
  high: PropTypes.string,
  last_trade: PropTypes.string,
  low: PropTypes.string,
  orderBook: PropTypes.shape({
    ask: PropTypes.arrayOf(
      PropTypes.arrayOf(
        PropTypes.string,
      ),
    ),
    bid: PropTypes.arrayOf(
      PropTypes.arrayOf(
        PropTypes.string,
      ),
    ),
  }).isRequired,
  orderBookFetch: PropTypes.func.isRequired,
  tickerFetch: PropTypes.func.isRequired,
  sell_price: PropTypes.string,
};

const mapStateToProps = ({ statistic: { orderBook, ticker } }) => ({
  orderBook,
  ...ticker,
});

const mapDispatchToProps = dispatch => ({
  tickerFetch: bindActionCreators(fetchTicker, dispatch),
  orderBookFetch: bindActionCreators(fetchOrderBook, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Dashboard);

