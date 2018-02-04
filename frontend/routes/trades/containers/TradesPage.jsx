import React from 'react';

import Grid from 'material-ui/Grid';
import Paper from 'material-ui/Paper';
import Typography from 'material-ui/Typography';

import LeftPanel from './LeftPanel';

const Content = () => (
  <Grid container spacing={24}>
    <Grid item xs={12} sm={3}>
      <Paper elevation={5}>
        <LeftPanel />
      </Paper>
    </Grid>
    <Grid item xs={12} sm={6}>
      <Paper elevation={5}>
        <Typography align="center" type="display1">
          Активный мониторинг в данный момент отсутствует
        </Typography>
      </Paper>
    </Grid>
    <Grid item xs={12} sm={3}>
      <Paper elevation={5}>
        <Typography align="center" type="display1">
          Список транзакций пуст
        </Typography>
      </Paper>
    </Grid>
  </Grid>
);

export default Content;
