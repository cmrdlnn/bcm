import React from 'react';
import PropTypes from 'prop-types';
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';

const ConfirmModal = ({
  body,
  confirmText,
  header,
  isOpen,
  onConfirm,
  onReject,
  rejectText,
  toggle,
}) => (
  <Modal isOpen={isOpen} toggle={toggle} className="modal-danger">
    <ModalHeader toggle={toggle}>{ header }</ModalHeader>
    { body ? <ModalBody>{ body }</ModalBody> : null }
    <ModalFooter>
      <Button color="danger" onClick={onConfirm}>{ confirmText }</Button>
      <Button color="secondary" onClick={onReject}>{ rejectText }</Button>
    </ModalFooter>
  </Modal>
);

ConfirmModal.defaultProps = {
  body: null,
  confirmText: 'Да',
  header: '',
  onConfirm: null,
  rejectText: 'Отмена',
  toggle: null,
};

ConfirmModal.propTypes = {
  body: PropTypes.string,
  confirmText: PropTypes.string,
  header: PropTypes.string,
  isOpen: PropTypes.bool.isRequired,
  onConfirm: PropTypes.func,
  onReject: PropTypes.func.isRequired,
  rejectText: PropTypes.string,
  toggle: PropTypes.func,
};

export default ConfirmModal;
