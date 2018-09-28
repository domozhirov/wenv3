const path = require('path');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const fs = require('fs');
const nodeModules = {};
fs.readdirSync('node_modules')
    .filter(x => {
        return ['.bin'].indexOf(x) === -1;
    })
    .forEach(mod => {
        nodeModules[mod] = 'commonjs ' + mod;
    });


module.exports = {
    context: path.join(__dirname, 'src'),
    entry: './index.ts',
    target: 'node',
    devtool: 'inline-source-map',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: /node_modules/
            }
        ]
    },
    plugins: [
        new CleanWebpackPlugin('dist'),
        new CopyWebpackPlugin([{ from: 'static', to: 'static' }])
    ],
    devServer: {
        contentBase: './dist'
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: 'index.js',
        path: path.resolve(__dirname, 'dist'),
    },
    externals: nodeModules,
    node: {
        __dirname: false,
        __filename: false,
    }
};
