import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Card, CardBody } from 'reactstrap';
import classNames from 'classnames';
import { mapToCssModules } from 'reactstrap/lib/utils';

class TickerCard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      valuesStyle: { valuesStyle: { color: '' } },
      value: this.formatValue(this.props.value),
    };
  }

  componentWillReceiveProps(nextProps) {
    const { value } = this.state;
    const nextValue = this.formatValue(nextProps.value);
    let valuesColor = {};
    if (value === 0) {
      valuesColor = { valuesStyle: { color: '' } };
    } else if (value < nextValue) {
      valuesColor = { valuesStyle: { color: '#28a745' } };
    } else if (value > nextValue) {
      valuesColor = { valuesStyle: { color: '#d50000' } };
    }
    this.setState({ value: nextValue, ...valuesColor });
  }

  formatValue = value => Math.round(parseFloat(value) * 1000) / 1000

  render() {
    const {
      children,
      className,
      color,
      cssModule,
      header,
      icon,
      invert,
      ...attributes
    } = this.props;
    const { value, valuesStyle } = this.state;

    const progress = { style: '', color, value };
    const card = { style: '', bgColor: '', icon };

    if (invert) {
      progress.style = 'progress-white';
      progress.color = '';
      card.style = 'text-white';
      card.bgColor = `bg-${color}`;
    }

    const classes = mapToCssModules(classNames(className, card.style, card.bgColor), cssModule);
    progress.style = classNames('progress-xs mt-3 mb-0', progress.style);

    return (
      <Card className={classes} {...attributes} style={{ height: '100%' }}>
        <CardBody>
          <div className="h1 text-muted text-left mb-2" style={{ float: 'left' }}>
            <i className="fa fa-dollar" />
          </div>
          <div className="h1 text-muted text-right mb-2">
            <i className="fa fa-bitcoin" />
          </div>
          <div className="h4 mb-0" style={valuesStyle}>
            { value }
          </div>
          <small className="text-muted text-uppercase font-weight-bold">{ children }</small>
        </CardBody>
      </Card>
    );
  }
}

TickerCard.defaultProps = {
  header: '87.500',
  icon: 'icon-people',
  color: 'info',
  value: '0',
  children: 'Visitors',
  invert: false,
};

TickerCard.propTypes = {
  header: PropTypes.string,
  icon: PropTypes.string,
  color: PropTypes.string,
  value: PropTypes.string,
  children: PropTypes.node,
  className: PropTypes.string,
  cssModule: PropTypes.object,
  invert: PropTypes.bool,
};

export default TickerCard;
