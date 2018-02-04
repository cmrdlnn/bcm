import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import Button from 'material-ui/Button';
import Grid from 'material-ui/Grid';
import Paper from 'material-ui/Paper';
import TextField from 'material-ui/TextField';
import Typography from 'material-ui/Typography';

import { signIn } from 'modules/user';

class Login extends Component {
  handleSubmit = (e) => {
    e.preventDefault();

    const { elements } = e.target;
    const data = ['password', 'username'].reduce((result, value) => {
      result[value] = elements[value];
      return result;
    }, {});

    this.props.signIn(data);
  }

  render() {
    return (
      <Grid align="center" container direction="column">
        <Grid item>
          <Paper elevation={5}>
            <form onSubmit={this.handleSubmit}>
              <Grid container direction="column">
                <Grid item>
                  <Typography align="center" type="title">
                    Вход в систему
                  </Typography>
                </Grid>
                <Grid item>
                  <TextField label="Имя пользователя" name="username" required />
                </Grid>
                <Grid item>
                  <TextField label="Пароль" name="password" required type="password" />
                </Grid>
                <Grid item>
                  <Button color="primary" raised type="submit">
                    Вход
                  </Button>
                </Grid>
              </Grid>
            </form>
          </Paper>
        </Grid>
      </Grid>
    );
  }
}

Login.propTypes = { signIn: PropTypes.func.isRequired };

function mapDispatchToProps(dispatch) {
  return { signIn: bindActionCreators(signIn, dispatch) };
}

export default connect(null, mapDispatchToProps)(Login);
