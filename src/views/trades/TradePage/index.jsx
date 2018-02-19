import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Card,
  CardBody,
  CardHeader,
  Col,
  Row,
  Table,
} from 'reactstrap';

import InfoRow from 'components/InfoRow';

import { clearTrade, fetchTrade } from 'modules/trades';

class TradesPage extends Component {
  componentWillMount() {
    const { match, tradeFetch } = this.props;
    const { id } = match.params;
    tradeFetch(id);
    this.fetcher = setInterval(() => tradeFetch(id), 10000);
  }

  componentWillUnmount() {
    clearInterval(this.fetcher);
    this.props.tradeClear();
  }

  render() {
    const { trade } = this.props;

    if (!trade) return null;

    const balanceUSD = (trade[1].balances && trade[1].balances.USD) || '0';
    const balanceBTC = (trade[1].balances && trade[1].balances.BTC) || '0';
    const reservedUSD = (trade[1].reserved && trade[1].reserved.USD) || '0';
    const reservedBTC = (trade[1].reserved && trade[1].reserved.BTC) || '0';

    return (
      <div className="animated fadeIn">
        <Row>
          <Col xs="4">
            <Card>
              <CardHeader>
                <i className="fa fa-balance-scale" />
                Информация по торгам
              </CardHeader>
              <CardBody>
                <InfoRow title="Выставленный старт-курс" value={trade[0].start_course} />
                <hr />
                <InfoRow title="Выставленный объём торгов" value={trade[0].order_price} />
                <hr />
                <InfoRow title="Текущий баланс в долларах" value={balanceUSD.replace(/(.*\..{2})(.+)/, '$1')} />
                <hr />
                <InfoRow title="Текущий баланс в биткоинах" value={balanceBTC.replace(/(.*\..{2})(.+)/, '$1')} />
                <hr />
                <InfoRow title="Долларов зарезервировано в ордерах" value={reservedUSD.replace(/(.*\..{2})(.+)/, '$1')} />
                <hr />
                <InfoRow title="Биткоинов зарезервировано в ордерах" value={reservedBTC.replace(/(.*\..{2})(.+)/, '$1')} />
              </CardBody>
            </Card>
          </Col>
          <Col xs="8">
            <Card>
              <CardHeader>
                <i className="fa fa-tasks" />
                Список ордеров
              </CardHeader>
              <CardBody>
                { trade[0].orders.length ? (
                  <Table hover bordered striped responsive size="sm">
                    <thead>
                      <tr>
                        <th>Дата/время</th>
                        <th>Операция</th>
                        <th>Цена</th>
                        <th>Количество</th>
                        <th>Сумма</th>
                      </tr>
                    </thead>
                    <tbody>
                      { trade[0].orders.map(order => (
                        <tr>
                          <td>{ order.created_at.toLocaleString('ru') }</td>
                          <td>{ order.type }</td>
                          <td>{ order.price }</td>
                          <td>{ order.quantity }</td>
                          <td>{ order.quantity * order.price }</td>
                        </tr>
                      ))}
                    </tbody>
                  </Table>
                ) : (
                  <h2 className="text-center">
                    В данных торгах ещё не выставленно ни одного ордера
                  </h2>
                )}
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = ({ trades: { current } }) => ({ trade: current });

const mapDispatchToProps = dispatch => ({
  tradeFetch: bindActionCreators(fetchTrade, dispatch),
  tradeClear: bindActionCreators(clearTrade, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(TradesPage));
