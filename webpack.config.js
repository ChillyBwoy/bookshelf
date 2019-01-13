const path = require('path');
const HTMLWebpackPlugin = require('html-webpack-plugin');

const IS_DEBUG = !process.argv.includes('--release');

module.exports = {
  mode: IS_DEBUG ? 'development' : 'production',
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
            options: {
              debug: true,
            }
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
              localIdentName: IS_DEBUG ? '[name]_[local]_[hash:base64:5]' : '[hash:base64:16]',
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
    contentBase: path.resolve(__dirname, 'public'),
    overlay: true
  }
};