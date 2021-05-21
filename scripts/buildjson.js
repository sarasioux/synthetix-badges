const badges = require('../configs/badges.js');
const fs = require('fs')

let writeJson, fileName, response;
for(let i in badges.badges) {
    writeJson = JSON.stringify(badges.badges[i]);
    fileName = process.cwd() + '/build/badges/' + i + '.json';
    fs.writeFileSync(fileName, writeJson);
    console.log('Build badge', i);
}
