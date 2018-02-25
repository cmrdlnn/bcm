import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { AlertList } from 'react-bs-notifier';

import { hideAlert } from 'modules/alerts';

const Notifier = ({ alertHide, alerts }) => (
  <AlertList
    alerts={alerts}
    dismissTitle="Закрыть"
    onDismiss={alertHide}
    position="bottom-right"
    timeout={3000}
  />
);

Notifier.propTypes = {
  alertHide: PropTypes.func.isRequired,
  alerts: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      type: PropTypes.string.isRequired,
      message: PropTypes.string.isRequired,
    }),
  ).isRequired,
};

const mapStateToProps = ({ alerts }) => ({ alerts });

const mapDispatchToProps = dispatch => ({ alertHide: bindActionCreators(hideAlert, dispatch) });

export default connect(mapStateToProps, mapDispatchToProps)(Notifier);
