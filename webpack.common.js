const path = require('path');

module.exports = {
  entry: path.join(__dirname, './frontend/index.jsx'),
  output: {
    path: path.join(__dirname, './public/'),
    filename: 'webpack.bundle.js',
    publicPath: '/',
  },
  module: {
    rules: [
      {
        test: /\.(jsx)$/,
        exclude: /node_modules/,
        use: 'babel-loader',
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(jpg)$/,
        use: ['file-loader'],
      },
    ],
  },
  resolve: { extensions: ['.js', '.jsx'] },
};
