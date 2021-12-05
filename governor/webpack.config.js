const path = require('path');
const zlib = require('zlib');
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');
const ESLintPlugin = require('eslint-webpack-plugin');
const ExtractTextPlugin = require('mini-css-extract-plugin');
const HtmlPlugin = require('html-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const CompressionPlugin = require('compression-webpack-plugin');

const esmpaths = (names) => {
  return names.map((name) => path.resolve(__dirname, `node_modules/${name}`));
};

const esModules = [
  '@xorkevin/substation',
  '@xorkevin/turbine',
  '@xorkevin/nuke',
  '@xorkevin/gov-ui',
];

const createConfig = (env, argv) => {
  const config = {
    target: 'web',

    context: path.resolve(__dirname, 'src'),
    entry: {
      main: ['main.js'],
    },
    resolve: {
      modules: [path.resolve(__dirname, 'src'), 'node_modules'],
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          include: [...esmpaths(esModules), path.resolve(__dirname, 'src')],
          use: ['babel-loader'],
        },
        {
          test: /\.s?css$/,
          use: [
            ExtractTextPlugin.loader,
            {loader: 'css-loader'},
            {loader: 'sass-loader'},
          ],
        },
        {
          test: /\.(ttf|otf|woff|woff2|svg|eot)/,
          type: 'asset/resource',
          generator: {
            filename: 'static/fonts/[name].[contenthash][ext]',
          },
        },
      ],
    },

    optimization: {
      moduleIds: 'deterministic',
      runtimeChunk: 'single',
      splitChunks: {
        chunks: 'all',
      },
      minimizer: [new TerserPlugin()],
    },

    plugins: [
      new ESLintPlugin(),
      new HtmlPlugin({
        title: 'Nuke',
        filename: 'index.html',
        inject: 'body',
        template: 'template/index.html',
      }),
      new ExtractTextPlugin({
        filename: 'static/[name].[contenthash].css',
      }),
      new CopyPlugin({
        patterns: [{from: 'public'}],
      }),
      new CompressionPlugin({
        test: /\.(html|js|css|json)(\.map)?$/,
        algorithm: 'gzip',
        compressionOptions: {level: 9},
        threshold: 0,
        minRatio: 1,
        filename: '[path][base].gz',
        deleteOriginalAssets: false,
      }),
      new CompressionPlugin({
        test: /\.(html|js|css|json)(\.map)?$/,
        algorithm: (input, _compressionOptions, cb) => {
          zlib.brotliCompress(
            input,
            {
              params: {
                [zlib.constants.BROTLI_PARAM_MODE]:
                  zlib.constants.BROTLI_MODE_TEXT,
                [zlib.constants.BROTLI_PARAM_QUALITY]: 11,
                [zlib.constants.BROTLI_PARAM_SIZE_HINT]:
                  Buffer.byteLength(input),
              },
            },
            cb,
          );
        },
        threshold: 0,
        minRatio: 1,
        filename: '[path][base].br',
        deleteOriginalAssets: false,
      }),
      new webpack.DefinePlugin({
        APIBASE_URL: JSON.stringify('/api'),
        COURIERBASE_URL: JSON.stringify(
          'http://go.governor.dev.localhost:8080',
        ),
      }),
    ],

    output: {
      path: path.resolve(__dirname, 'dc.run/static'),
      publicPath: '/',
      filename: 'static/[name].[contenthash].js',
    },

    devtool: false,
  };

  return config;
};

module.exports = createConfig;
