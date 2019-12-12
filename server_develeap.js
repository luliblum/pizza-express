const express = require('express');

const app = express();



const path = require('path');

const bodyParser = require('body-parser');



const generateId = require('./lib/generate-id');



var redis = require("redis"),

 // client = redis.createClient('6379');

  client = redis.createClient(process.env.REDIS_URL); 



app.use(express.static('static'));

app.use(bodyParser.urlencoded({ extended: true }));



app.set('view engine', 'jade');

app.set('port', process.env.PORT || 3000);



app.locals.title = 'Pizza Express'

app.locals.pizzas = {};


var socket = io.connect('http://your-socket-io-server');
socket.on('datetime', function (data) {
  $("#clock").text(new Date(data));
});
