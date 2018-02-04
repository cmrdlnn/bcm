const webpack = require('webpack');
const merge = require('webpack-merge');
const common = require('./webpack.config.js');

const isWDS = process.argv.find(arg => arg.includes('webpack-dev-server'));

const additionalOptions = !isWDS ? {} : {
  devServer: { headers: { 'Access-Control-Allow-Origin': '*' } },
  output: { publicPath: 'http://0.0.0.0:8080/' }
};

module.exports = merge(common, {
  plugins: [
    new webpack.DefinePlugin({ 'process.env': { NODE_ENV: JSON.stringify('development') } })
  ]
}, additionalOptions);
