const {homedir} = require('os');

module.exports = {
  "httpPort": 3000,
  "socketPort": 3001,
  "projectDir": homedir(),
  "livereload": true,
  "public": true,
};
