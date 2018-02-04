const path = require('path');

module.exports = {
  entry: path.join(__dirname, './frontend/index.jsx'),
  output: {
    path: path.join(__dirname, './public/'),
    filename: 'webpack.bundle.js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: 'babel-loader'
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(jpg|svg|woff|woff2)$/,
        use: ['file-loader']
      }
    ]
  },
  resolve: {
    extensions: ['*','.js', '.jsx'],
    modules: [path.resolve(__dirname, './frontend'), 'node_modules']
  }
};
