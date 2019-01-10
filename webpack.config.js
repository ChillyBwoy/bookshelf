const path = require('path');
const HTMLWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: 'development',
  devtool: 'source-map',
  entry: './src/index.js',
  target: 'web',
  output: {
    filename: '[name].js',
    path: path.join(__dirname, 'dist'),
    publicPath: '/',
  },
  resolve: {
    modules: [
      path.join(__dirname, 'src'),
      'node_modules',
    ],
    extensions: ['.elm', '.js', '.css']
  },
  module: {
    rules: [
      // all files with a `.ts` or `.tsx` extension will be handled by `ts-loader`
      {
        test: /\.elm?$/,
        exclude: [
          /elm-stuff/,
          /node_modules/,
        ],
        use: [{
            loader: 'elm-css-modules-loader',
          },
          {
            loader: 'elm-webpack-loader',
          }
        ],
      },
      {
        test: /\.css$/,
        exclude: /node_modules/,
        use: [{
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
            options: {
              importLoaders: 1,
              modules: true,
            }
          },
          {
            loader: 'postcss-loader'
          }
        ]
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loader: 'file-loader',
        options: {
          name: '[name]-[hash].[ext]'
        }
      }
    ]
  },
  plugins: [
    new HTMLWebpackPlugin({
      // Use this template to get basic responsive meta tags
      template: 'src/html/index.html',
      // inject details of output file at end of body
      inject: 'body'
    })
  ],
  devServer: {
    inline: true,
    stats: 'errors-only',
    contentBase: path.join(__dirname, 'src/assets'),
    historyApiFallback: true,
  }
};