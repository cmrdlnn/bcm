import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {
  Card,
  CardBody,
  CardHeader,
  Table,
} from 'reactstrap';

import { fetchTrade } from 'modules/trades';

class TradesPage extends Component {
  componentWillMount() {
    const { match, tradeFetch } = this.props;
    const { id } = match.params;
    console.log(id)
    if (!id || ['active', 'archive', 'create'].includes(id)) return;

    tradeFetch(id);
  }

  render() {
    if (!this.props.current) return null;
    console.log(this.props.trades[this.props.match.params.id])
    return (
      <div className="animated fadeIn">
        <Card>
          <CardHeader>
            <i className="fa fa-tasks" />
            Информация по торгам
          </CardHeader>
          <CardBody>
          фывфыв
          </CardBody>
        </Card>
      </div>
    );
  }
}

const mapStateToProps = ({ trades }) => ({ trades });

const mapDispatchToProps = dispatch => ({
  tradeFetch: bindActionCreators(fetchTrade, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(TradesPage));
