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
  constructor(props) {
    super(props);
    this.state = { closed: this.props.location.pathname.includes('archive') };
  }

  componentWillMount() {
    this.props.indexTrades({ closed: this.state.closed });
  }

  render() {
    const { history, trades } = this.props;
    const { closed } = this.state;
    console.log(this.props)
    return (
      <div className="animated fadeIn">
        <Card>
          <CardHeader>
            <i className="fa fa-tasks" />
            { closed ? 'Закрытые торги' : 'Активные торги' }
          </CardHeader>
          <CardBody>
            { trades.length ? (
              <Table hover bordered striped responsive size="sm">
                <thead>
                  <tr>
                    <th>Старт-курс</th>
                    <th>Маржа</th>
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
                        <td>{ trade.start_course }</td>
                        <td>{ trade.margin }</td>
                        <td>{ trade.order_price }</td>
                        <td>{ new Date(trade.created_at).toLocaleString('ru') }</td>
                      </tr>
                    ))
                  }
                </tbody>
              </Table>
          ) : (
            <h2 className="text-center">
              В системе нет { closed ? 'закрытых' : 'активных' } торгов
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
  indexTrades: bindActionCreators(indexTrades, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(TradesPage);
