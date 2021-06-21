var express = require('express')
var app = express()

var PORT = process.env.PORT || 8080;

app.get('/', function(req, res) {
	res.send('Hola, Mundo!\n');
});

app.listen(PORT);
console.log("Started on localhost:" + PORT);
