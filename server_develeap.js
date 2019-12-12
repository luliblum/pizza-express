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


var xmlHttp;
function srvTime(){
    try {
        //FF, Opera, Safari, Chrome
        xmlHttp = new XMLHttpRequest();
    }
    catch (err1) {
        //IE
        try {
            xmlHttp = new ActiveXObject('Msxml2.XMLHTTP');
        }
        catch (err2) {
            try {
                xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (eerr3) {
                //AJAX not supported, use CPU time.
                alert("AJAX not supported");
            }
        }
    }
    xmlHttp.open('HEAD',window.location.href.toString(),false);
    xmlHttp.setRequestHeader("Content-Type", "text/html");
    xmlHttp.send('');
    return xmlHttp.getResponseHeader("Date");
}

var st = srvTime();
