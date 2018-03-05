import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Button } from 'reactstrap';

class Form extends Component {
  handelSubmit = (e) => {
    const { onSubmit, withoutReset } = this.props
    e.preventDefault();
    const form = e.target;
    const json = Array.from(form.elements).reduce((result, element) => {
      if (element.name) result[element.name] = element.value;
      return result;
    }, {});
    if (!withoutReset) form.reset();
    onSubmit(json);
  }

  render() {
    const { buttonClassName, buttonText, children, className, style, withoutButton } = this.props;

    return (
      <form className={className} onSubmit={this.handelSubmit} style={style}>
        { children }
        { withoutButton ? null : (
          <Button className={buttonClassName} color="primary" type="submit">{buttonText}</Button>
        )}
      </form>
    );
  }
}

Form.defaultProps = {
  buttonClassName: '',
  className: '',
  style: null,
  withoutButton: false,
  withoutReset: false,
};

Form.propTypes = {
  buttonClassName: PropTypes.string,
  buttonText: PropTypes.string.isRequired,
  children: PropTypes.node.isRequired,
  className: PropTypes.string.isRequired,
  onSubmit: PropTypes.func.isRequired,
  style: PropTypes.object,
  withoutButton: PropTypes.bool,
  withoutReset: PropTypes.bool,
};

export default Form;
