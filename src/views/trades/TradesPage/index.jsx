import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Card,
  CardBody,
  CardHeader,
  Table,
} from 'reactstrap';

import { indexTrades } from 'modules/trades';

class TradesPage extends Component {
  componentWillMount() {
    const { tradesIndex, location } = this.props;
    this.getTrades(location, tradesIndex);
  }

  componentWillReceiveProps(nextProps) {
    const { tradesIndex, location } = nextProps;
    if (location.pathname !== this.props.location.pathname) {
      this.getTrades(location, tradesIndex);
    }
  }

  getTrades = (location, tradesIndex) => {
    let isClosed = false;
    if (location.pathname.includes('archive')) {
      isClosed = true;
    }
    tradesIndex({ closed: isClosed });
  }

  render() {
    const { history, location, trades } = this.props;
    const isClosed = location.pathname.includes('archive');

    return (
      <div className="animated fadeIn">
        <Card>
          <CardHeader>
            <i className="fa fa-tasks" />
            { isClosed ? 'Закрытые торги' : 'Активные торги' }
          </CardHeader>
          <CardBody>
            { trades.length ? (
              <Table hover bordered striped responsive size="sm">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Старт-курс</th>
                    <th>Объём торгов</th>
                    <th>Дата и время создания</th>
                  </tr>
                </thead>
                <tbody>
                  {
                    trades.map((trade, i) => (
                      <tr
                        key={trade.id}
                        onClick={() => history.push(`/trades/${trade.id}`)}
                        style={{ cursor: 'pointer' }}
                      >
                        <th scope="row">{ i + 1 }</th>
                        <td>{ trade.start_course }</td>
                        <td>{ trade.order_price }</td>
                        <td>{ new Date(trade.created_at).toLocaleString('ru') }</td>
                      </tr>
                    ))
                  }
                </tbody>
              </Table>
          ) : (
            <h2 className="text-center">
              В системе нет { isClosed ? 'закрытых' : 'активных' } торгов
            </h2>
          )}
          </CardBody>
        </Card>
      </div>
    );
  }
}

const mapStateToProps = ({ trades: { all } }) => ({ trades: all });

const mapDispatchToProps = dispatch => ({
  tradesIndex: bindActionCreators(indexTrades, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(TradesPage);
