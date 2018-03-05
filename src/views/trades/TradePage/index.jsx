import React, { Component, Fragment } from 'react';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Button,
  Card,
  CardBody,
  CardHeader,
  Row,
  Table,
} from 'reactstrap';

import ConfirmModal from 'components/ConfirmModal';
import InfoRow from 'components/InfoRow';

import { clearTrade, fetchTrade, updateTrade } from 'modules/trades';

const onCloseTradeMessage = 'После того, как вы остановите торги - все текущие ордера ' +
  'отменятся, а купленная в рамках торгов криптовалюта (если таковая имеется) останется на ' +
  'ващем балансе';

class TradesPage extends Component {
  constructor(props) {
    super(props);
    this.state = { modalIsOpen: false };
  }

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

  upToEighthDecimalPlace = value => Math.round(value * 100000000) / 100000000

  convertStatus = (status) => {
    switch(status) {
      case 'processing':
        return { text: 'В обработке', style: { color: '#007bff' } };

      case 'fulfilled':
        return { text: 'Исполнен', style: { color: '#28a745' } };

      case 'canceled':
        return { text: 'Отменён', style: { color: '#ff7b00' } };

      case 'error':
        return { text: 'Ошибка', style: { color: '#dc3545' } };
    }
  }

  render() {
    const { trade, tradeUpdate } = this.props;

    if (!trade) return null;

    const balanceUSD = (trade[1].balances && trade[1].balances.USD) || '0';
    const balanceBTC = (trade[1].balances && trade[1].balances.BTC) || '0';
    const reservedUSD = (trade[1].reserved && trade[1].reserved.USD) || '0';
    const reservedBTC = (trade[1].reserved && trade[1].reserved.BTC) || '0';

    return (
      <div className="animated fadeIn">
        <ConfirmModal
          body={onCloseTradeMessage}
          header="Вы действительно хотите закрыть торги?"
          isOpen={this.state.modalIsOpen}
          onConfirm={() => {
            this.setState({ modalIsOpen: false });
            tradeUpdate(trade[0].id, { closed: true }, 'Торги успешно закрыты');
          }}
          onReject={() => this.setState({ modalIsOpen: false })}
        />
        <Row className="mb-4">
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
              <InfoRow title="Текущий баланс в долларах" value={balanceUSD} />
              <hr />
              <InfoRow title="Текущий баланс в биткоинах" value={balanceBTC} />
              <hr />
              <InfoRow title="Долларов зарезервировано в ордерах" value={reservedUSD} />
              <hr />
              <InfoRow title="Биткоинов зарезервировано в ордерах" value={reservedBTC} />
              { trade[0].closed ? null : (
                <Fragment>
                  <hr />
                  <Button
                    block
                    color="primary"
                    onClick={() => this.setState({ modalIsOpen: true })}
                    outline
                  >
                    Закрыть торги
                  </Button>
                </Fragment>
              )}
            </CardBody>
          </Card>
        </Row>
        <Row>
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
                      <th>Статус</th>
                    </tr>
                  </thead>
                  <tbody>
                    { trade[0].orders
                        .sort((a, b) => (new Date(a.created_at) >= new Date(b.created_at) ? 1 : -1))
                        .map((order) => {
                          const isBuy = order.type === 'buy';
                          const quantity = this.upToEighthDecimalPlace(order.quantity);
                          const price = this.upToEighthDecimalPlace(order.price);
                          const sum = this.upToEighthDecimalPlace(order.quantity * order.price);
                          const status = this.convertStatus(order.state);
                          return (
                            <tr>
                              <td>{ new Date(order.created_at).toLocaleString('ru') }</td>
                              <td
                                style={{ color: isBuy ? '#347ffb' : '#ff0026' }}
                              >
                                { isBuy ? 'Покупка' : 'Продажа' }
                              </td>
                              <td>{ price }</td>
                              <td>{ quantity }</td>
                              <td>{ sum }</td>
                              <td style={status.style}>{ status.text }</td>
                            </tr>
                          );
                        })
                    }
                  </tbody>
                </Table>
              ) : (
                <h2 className="text-center">
                  В данных торгах ещё не выставленно ни одного ордера
                </h2>
              )}
            </CardBody>
          </Card>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = ({ trades: { current } }) => ({ trade: current });

const mapDispatchToProps = dispatch => ({
  tradeFetch: bindActionCreators(fetchTrade, dispatch),
  tradeClear: bindActionCreators(clearTrade, dispatch),
  tradeUpdate: bindActionCreators(updateTrade, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(TradesPage));
