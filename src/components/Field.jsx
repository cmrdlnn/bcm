import React from 'react';
import PropTypes from 'prop-types';
import {
  FormGroup,
  FormText,
  Input,
  InputGroup,
  InputGroupAddon,
  InputGroupText,
  Label,
} from 'reactstrap';

const Field = ({
  addon,
  helper,
  name,
  placeholder,
  required,
  title,
  type,
}) => (
  <FormGroup>
    { title ? <Label for={name}>{ title }</Label> : null }
    <InputGroup>
      { !addon ? null : (
        <InputGroupAddon addonType="prepend">
          <InputGroupText>
            { addon }
          </InputGroupText>
        </InputGroupAddon>
      )}
      <Input
        id={name}
        name={name}
        placeholder={placeholder}
        required={required}
        type={type}
      />
    </InputGroup>
    { helper ? <FormText>{ helper }</FormText> : null }
  </FormGroup>
);

Field.defaultProps = {
  addon: null,
  helper: null,
  name: null,
  placeholder: null,
  required: false,
  title: null,
  type: 'text',
};

Field.propTypes = {
  addon: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.node,
  ]),
  helper: PropTypes.string,
  name: PropTypes.string,
  placeholder: PropTypes.string,
  required: PropTypes.bool,
  title: PropTypes.string,
  type: PropTypes.string,
};

export default Field;
