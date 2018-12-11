const path = require('path');
const fs = require('fs');

const patchFilepath = path.join(__dirname, 'build.js');
const currentFilepath = path.join(__dirname, '../..', 'node_modules', 'node-sass', 'scripts', 'build.js');

fs.copyFileSync(patchFilepath, currentFilepath);
