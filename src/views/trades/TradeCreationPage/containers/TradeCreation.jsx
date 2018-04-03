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

import { fetchOrderBook, fetchPairSettings } from 'modules/statistic';
import { createTrade } from 'modules/trades';

import DropdownField from 'components/DropdownField';
import Field from 'components/Field';
import Form from 'components/Form';
import InfoRow from 'components/InfoRow';
import OrderList from 'components/OrderList';

class TradeCreation extends Component {
  constructor(props) {
    super(props);
    this.state = {
      currencies: {},
      sourceCurrency: null,
      targetCurrency: null,
    };
  }

  componentWillMount() {
    this.props.pairSettingsFetch();
  }

  componentWillReceiveProps(nextProps) {
    const currenciesLength = Object.keys(this.state.currencies).length;
    const nextSettingsKeys = Object.keys(nextProps.pairSettings);
    if (currenciesLength === 0 && nextSettingsKeys.length !== 0) {
      const currencies = {};
      nextSettingsKeys.forEach((pair) => {
        const match = pair.match(/^(.+)_(.+)$/);
        if (currencies[match[2]]) {
          currencies[match[2]].push(match[1]);
        } else {
          currencies[match[2]] = [match[1]];
        }
      });
      this.setState({ currencies, sourceCurrency: Object.keys(currencies)[0] });
    }
  }

  componentWillUpdate(nextProps, nextState) {
    const { sourceCurrency, targetCurrency } = nextState;
    if (
      (!this.state.sourceCurrency && sourceCurrency) ||
      (!this.state.targetCurrency && targetCurrency)
    ) {
      clearTimeout(this.timeout);
      const { orderBookFetch } = this.props;
      this.timeout = setTimeout(
        () => {
          orderBookFetch(this.pair());
          clearInterval(this.fetcher);
          this.fetcher = setInterval(() => orderBookFetch(this.pair()), 6000);
        },
        200,
      );
    }
  }

  componentWillUnmount() {
    clearTimeout(this.timeout);
    clearInterval(this.fetcher);
  }

  selectSourceCurrency = (sourceCurrency) => {
    this.setState({ sourceCurrency });
  }

  selectTargetCurrency = (targetCurrency) => {
    this.setState({ targetCurrency });
  }

  createTrade = (data) => {
    this.props.tradeCreate({ ...data, pair: this.pair() });
  }

  pair = () => {
    const { sourceCurrency, targetCurrency } = this.state;
    return `${targetCurrency}_${sourceCurrency}`;
  }

  render() {
    const {
      ask,
      ask_top: askTop,
      balances,
      bid,
      bid_top: bidTop,
      pairSettings: { [this.pair()]: settings },
    } = this.props;
    const { currencies, sourceCurrency, targetCurrency } = this.state;
    const quantity = (settings && settings.min_quantity) || 0;

    return (
      <Fragment>
        <Col xs="4">
          <Card>
            <CardHeader>
              <i className="fa fa-balance-scale" />
              Создание торгов
            </CardHeader>
            <CardBody>
              <Form
                onSubmit={this.createTrade}
                buttonText="Создать"
              >
                Исходная валюта:
                <DropdownField
                  className="mb-2"
                  items={Object.keys(currencies)}
                  onSelect={this.selectSourceCurrency}
                />
                Целевая валюта:
                <DropdownField
                  className="mb-2"
                  items={currencies[sourceCurrency]}
                  onSelect={this.selectTargetCurrency}
                />
                <Field
                  addon={<i className="fa fa-dollar" />}
                  helper="Цена за целевую валюту, опустившись ниже которой система начнёт покупать"
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
                  helper="Количество исходной валюты на счету, которая войдёт в оборот торгов"
                  max={balances && balances[sourceCurrency]}
                  min={Math.ceil(quantity * askTop)}
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
                <InfoRow title="Баланс исходной валюты на счету" value={balances && balances[sourceCurrency]} />
                <hr />
                <InfoRow title="Баланс целевой валюты на счету" value={balances && balances[targetCurrency]} />
                <hr />
                <InfoRow
                  helper="Исходной валюты за целевую среди текущих ордеров"
                  title="Минимальная цена продажи"
                  value={askTop}
                />
                <hr />
                <InfoRow
                  helper="Исходной валюты за целевую среди текущих ордеров"
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

TradeCreation.defaultProps = {
  ask: [],
  ask_top: '0',
  balances: null,
  bid: [],
  bid_top: '0',
};

TradeCreation.propTypes = {
  ask: PropTypes.arrayOf(
    PropTypes.arrayOf(
      PropTypes.string,
    ),
  ),
  ask_top: PropTypes.string,
  balances: PropTypes.objectOf(PropTypes.string),
  bid: PropTypes.arrayOf(
    PropTypes.arrayOf(
      PropTypes.string,
    ),
  ),
  bid_top: PropTypes.string,
  orderBookFetch: PropTypes.func.isRequired,
  pairSettings: PropTypes.objectOf(
    PropTypes.object,
  ).isRequired,
  pairSettingsFetch: PropTypes.func.isRequired,
  tradeCreate: PropTypes.func.isRequired,
};

const mapStateToProps = ({ statistic: { orderBook, pairSettings } }) => ({
  ...orderBook,
  pairSettings,
});

const mapDispatchToProps = dispatch => ({
  orderBookFetch: bindActionCreators(fetchOrderBook, dispatch),
  pairSettingsFetch: bindActionCreators(fetchPairSettings, dispatch),
  tradeCreate: bindActionCreators(createTrade, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(TradeCreation);
