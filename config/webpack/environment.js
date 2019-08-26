const { environment } = require('@rails/webpacker')

environment.loaders.insert('javascript', {
  test: /\.(js|jsx|mjs)$/,
  use: 'babel-loader',
  exclude: /node_modules(?!\/playbook-ui)/
})

module.exports = environment
