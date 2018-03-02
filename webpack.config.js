const path = require('path');

module.exports = {
  entry: path.join(__dirname, './src/index.jsx'),
  output: {
    path: path.join(__dirname, './public/'),
    filename: 'webpack.bundle.js',
    publicPath: '/',
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: 'babel-loader',
      },
      {
        test: /\.(css|scss)$/,
        use: ['style-loader', 'css-loader', 'sass-loader'],
      },
      {
        test: /\.(svg|png|jpg|jpeg|gif|ico|eot|woff|woff2|ttf)$/,
        use: ['file-loader'],
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.jsx'],
    modules: [path.resolve(__dirname, './src'), 'node_modules'],
  },
};
