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

  componentWillMount() {
    console.log(this.props)

  }

  componentWillReceiveProps(nextProps) {
    console.log(nextProps)
    if (nextProps.balances) this.setState({ step: this.state.step + 1 });
  }

  render() {
    const Step = steps[this.state.step];

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
