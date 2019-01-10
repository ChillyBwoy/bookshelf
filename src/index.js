const {
  Elm
} = require('./elm/Main');

var app = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: Math.random(),
});