import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Button } from 'reactstrap';

class Form extends Component {
  handelSubmit = (e) => {
    e.preventDefault();
    const form = e.target;
    const json = Array.from(form.elements).reduce((result, element) => {
      if (element.name) result[element.name] = element.value;
      return result;
    }, {});
    form.reset();
    this.props.onSubmit(json);
  }

  render() {
    const { buttonText, children } = this.props;

    return (
      <form onSubmit={this.handelSubmit} style={{ marginBottom: '1.5rem' }}>
        { children }
        <Button type="submit" color="primary">{buttonText}</Button>
      </form>
    );
  }
}

Form.propTypes = {
  buttonText: PropTypes.string.isRequired,
  children: PropTypes.node.isRequired,
  onSubmit: PropTypes.func.isRequired,
};

export default Form;
