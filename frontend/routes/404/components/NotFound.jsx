import React from 'react';
import Grid from 'material-ui/Grid';
import Paper from 'material-ui/Paper';
import Typography from 'material-ui/Typography';

const NotFound = () => (
  <Grid align="center" container direction="column">
    <Grid item xs={6}>
      <Paper elevation={5}>
        <Typography align="center" type="display1">
          404, cтраница не найдена
        </Typography>
      </Paper>
    </Grid>
  </Grid>
);

export default NotFound;
