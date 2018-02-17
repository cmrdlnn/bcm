import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Row } from 'reactstrap';

import CredentialsForm from './containers/CredentialsForm';
import TradeCreation from './containers/TradeCreation';

const steps = [
  CredentialsForm,
  TradeCreation,
];

class TradeCreationPage extends Component {
  constructor(props) {
    super(props);
    this.state = { step: 0 };
  }

  componentWillReceiveProps(nextProps) {
    const step = this.props.balances === nextProps.balances ? 0 : 1;
    this.setState({ step });
  }

  render() {
    const Step = steps[this.state.step];

    if (!Step) return null;

    return (
      <div className="animated fadeIn">
        <Row>
          <Step balances={this.props.balances} />
        </Row>
      </div>
    );
  }
}

const mapStateToProps = ({ user: { balances } }) => ({ balances });

export default connect(mapStateToProps)(TradeCreationPage);
