import React from 'react';

import Button from 'material-ui/Button';
import Grid from 'material-ui/Grid';
import TextField from 'material-ui/TextField';
import Typography from 'material-ui/Typography';

const LeftPanel = () => (
  <Grid alignItems="stretch" container direction="column">
    <Grid item>
      <Typography align="center" type="title">
        Создание мониторинга
      </Typography>
    </Grid>
    <Grid item>
      <TextField label="Старт-курс" required fullWidth />
    </Grid>
    <Grid item>
      <TextField label="Маржа" required fullWidth />
    </Grid>
    <Grid item>
      <Button color="primary" raised type="submit">
        Старт
      </Button>
    </Grid>
  </Grid>
);

export default LeftPanel;
