import React, { Component } from 'react';
import { Row, Col } from 'reactstrap';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { fetchTicker } from 'modules/statistic';

import Widget04 from './components/Widget04';

class Widgets extends Component {
  componentWillMount() {
    const { tickerFetch } = this.props;
    tickerFetch();
    this.ticker = setInterval(tickerFetch, 6000);
  }

  componentWillUnmount() {
    clearInterval(this.ticker);
    this.ticker = null;
  }

  render() {
    const {
      high,
      low,
      avg,
      last_trade,
      buy_price,
      sell_price,
    } = this.props;

    return (
      <div className="animated fadeIn">
        <Row>
          <Col sm="6" md="2">
            <Widget04 icon="icon-people" color="info" header="87.500" value={high}>максимальная цена сделки за 24 часа</Widget04>
          </Col>
          <Col sm="6" md="2">
            <Widget04 icon="icon-user-follow" color="success" header="385" value={low}>минимальная цена сделки за 24 часа</Widget04>
          </Col>
          <Col sm="6" md="2">
            <Widget04 icon="icon-basket-loaded" color="warning" header="1238" value={avg}>средняя цена сделки за 24 часа</Widget04>
          </Col>
          <Col sm="6" md="2">
            <Widget04 icon="icon-pie-chart" color="primary" header="28%" value={last_trade}>цена последней сделки</Widget04>
          </Col>
          <Col sm="6" md="2">
            <Widget04 icon="icon-speedometer" color="danger" header="5:34:11" value={buy_price}>текущая максимальная цена покупки</Widget04>
          </Col>
          <Col sm="6" md="2">
            <Widget04 icon="icon-speech" color="info" header="972" value={sell_price}>текущая минимальная цена продажи</Widget04>
          </Col>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = ({ statistic: { ticker } }) => ({ ...ticker });

const mapDispatchToProps = dispatch => ({
  tickerFetch: bindActionCreators(fetchTicker, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Widgets);

