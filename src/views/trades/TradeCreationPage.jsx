import React, { Component } from 'react';
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

  onNextStep = () => {
    const { step } = this.state;
    if (step + 1 >= steps.length) this.props.history.push('/');
    this.setState({ step: step + 1 });
  }

  render() {
    const Step = steps[this.state.step];

    return (
      <div className="animated fadeIn">
        <Row>
          <Step onNextStep={this.onNextStep} />
        </Row>
      </div>
    );
  }
}

export default TradeCreationPage;
