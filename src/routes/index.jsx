import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Route, Switch, withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { checkAuth } from 'modules/user';

import Spinner from 'components/Spinner';

import Login from 'views/Pages/Login';
import Page404 from 'views/Pages/Page404';
import Page500 from 'views/Pages/Page500';
// import Register from './views/Pages/Register';

import Full from 'containers/Full';

class Routes extends Component {
  componentWillMount() {
    this.props.checkAuth();
  }

  render() {
    if (this.props.fetching) return <Spinner />;

    return (
      <Switch>
        <Route exact path="/login" name="Login Page" component={Login} />
        { /* <Route exact path="/register" name="Register Page" component={Register} /> */ }
        <Route exact path="/404" name="Page 404" component={Page404} />
        <Route exact path="/500" name="Page 500" component={Page500} />
        <Route
          path="/"
          name="Home"
          component={Full}
        />
      </Switch>
    );
  }
}

Routes.defaultProps = { fetching: null };

Routes.propTypes = {
  checkAuth: PropTypes.func.isRequired,
  fetching: PropTypes.bool,
};

const mapStateToProps = ({ user: { fetching } }) => ({ fetching });

const mapDispatchToProps = dispatch => ({
  checkAuth: bindActionCreators(checkAuth, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Routes));

