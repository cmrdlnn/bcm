import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Redirect, Route, Switch } from 'react-router';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import Grid from 'material-ui/Grid';
import { CircularProgress } from 'material-ui/Progress';

import { checkAuthentication } from 'modules/user';

import Header from 'components/Header';
import HeaderToolbar from 'components/HeaderToolbar';

import Login from './login';
import NotFound from './404';
import Trades from './trades';

const rotes = [
  Login,
  NotFound,
  Trades
];

class Routes extends Component {
  componentWillMount() {
    this.props.checkAuthentication();
  }

  render() {
    return (
      <Fragment>
        <Header>
          {
            rotes.reduce((result, route, i) => {
              if (route.header) {
                result.push(
                  <Route
                    key={`header-${i}`}
                    path={route.path}
                    exact={route.exact}
                    render={() => <HeaderToolbar items={route.header} />}
                  />
                );
              }
              return result;
            }, [])
          }
        </Header>
        { this.props.fetching ? (
          <Grid align="center" container direction="column">
            <Grid item xs={6}>
              <CircularProgress size={80} thickness={7} />
            </Grid>
          </Grid>
        ) : (
          <Switch>
            {
              rotes.map((route, i) => (
                <Route key={`header-${i}`} path={route.path} exact={route.exact} component={route.main} />
              ))
            }
          </Switch>
        )}
      </Fragment>
    );
  }
}

Routes.defaultProps = { fetching: false };

Routes.propTypes = {
  checkAuthentication: PropTypes.func.isRequired,
  fetching: PropTypes.bool
};

function mapStateToProps({ user: { fetching } }) {
  return { fetching };
}

function mapDispatchToProps(dispatch) {
  return { checkAuthentication: bindActionCreators(checkAuthentication, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(Routes);
