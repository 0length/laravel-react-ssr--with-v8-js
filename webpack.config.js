var path = require('path')

module.exports = [
    {
        mode: 'development',
        target: 'web',
        entry: {
            'index2.js': path.resolve(__dirname, 'src/index.ts'),
            // 'multipleRoutes.js': path.resolve(__dirname, 'view/portfolio/routes.js')
        },
        resolve: {
            // Add `.ts` and `.tsx` as a resolvable extension.
            extensions: [ '.tsx', '.ts', '.js'],
        },
        devtool: 'inline-source-map',
        module: {
            rules: [{
                test: /\.tsx?$/,
                exclude: /node_modules/,
                use: {
                  loader: 'ts-loader',
                }
            },{
                test:/\.css$/,
                use:['css-loader']
            }]
        },
        output: {
            path: path.resolve(__dirname, 'public/dist'),
            filename: '[name]'
        },
            // When importing a module whose path matches one of the following, just
        // assume a corresponding global variable exists and use that instead.
        // This is important because it allows us to avoid bundling all of our
        // dependencies, which allows browsers to cache those libraries between builds.
        // externals: {
        // 	"react": "React",
        // 	"react-dom": "ReactDOM"
        // },
    }
]