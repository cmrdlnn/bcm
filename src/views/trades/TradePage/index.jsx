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
} from 'reactstrap';

import InfoRow from 'components/InfoRow';

import { clearTrade, fetchTrade } from 'modules/trades';

class TradesPage extends Component {
  componentWillMount() {
    this.updateComponent(this.props);
  }

  componentWillReceiveProps(nextProps) {
    this.updateComponent(nextProps);
  }

  updateComponent = (props) => {
    const { match, trade, tradeClear, tradeFetch } = props;
    const { id } = match.params;

    if (!id || ['active', 'archive', 'create'].includes(id)) {
      if (trade) tradeClear();
      return;
    }

    if (!trade) tradeFetch(id);
  }

  render() {
    const { trade } = this.props;

    if (!trade) return null;

    return (
      <div className="animated fadeIn">
        <Row>
          <Col xs="6">
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
                <InfoRow title="Текущий баланс в долларах" value={trade[1].balances.USD} />
                <hr />
                <InfoRow title="Текущий баланс в биткоинах" value={trade[1].balances.BTC} />
                <hr />
                <InfoRow title="Долларов зарезервировано в ордерах" value={trade[1].reserved.USD} />
                <hr />
                <InfoRow title="Биткоинов зарезервировано в ордерах" value={trade[1].reserved.BTC} />
              </CardBody>
            </Card>
          </Col>
          <Col xs="6">
            <Card>
              <CardHeader>
                <i className="fa fa-tasks" />
                Список действий
              </CardHeader>
              <CardBody>
              фывфыв
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
