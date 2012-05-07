#!/usr/bin/env node


var isOSX = ('darwin' === process.platform);


function getvepath() {
    return process.env.NODE_PATH;
}



var program = require('./commander');
program.version('0.1');
program.usage('[options] [path]');
program.option('-a, --all', 'all in nvm packages. ignore all options.');
program.option('-p, --packages [PACKAGES...]', 'give packages name. default is a `coffee script` package.');
program.option('-s, --standard-packages [STANDARD_PACKAGES...]', 'give packages name. for the standard library.give packages name.');
program.option('--no-nvm', 'not include the nvm.');
program.option('--allow-testcode', 'include the test code.');
  // program. option('-L, --no-logs', 'disable request logging', Number, 3000)
program.parse(process.argv);



// vim: set et fenc=utf-8 ft=javascript ff=unix sts=0 sw=4 ts=4 :
