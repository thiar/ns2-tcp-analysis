var lineReaderReno = require('readline').createInterface({
  input: require('fs').createReadStream('reno.tr')
});

reno=[]

lineReaderReno.on('line', function (line) {
  str = line.split(" ");
  typeId=str[0]
  time =str[1]
  source=str[2]
  dest=str[3]
  packetType=str[4]
  seq=str[10]
  data = {}
  data.typeId=typeId
  data.time=time
  data.source=source
  data.dest=dest
  data.seq=seq
  data.packetType=packetType
  reno.push(data)
});

var lineReaderVegas = require('readline').createInterface({
  input: require('fs').createReadStream('vegas.tr')
});

vegas=[]

lineReaderVegas.on('line', function (line) {
  str = line.split(" ");
  typeId=str[0]
  time =str[1]
  source=str[2]
  dest=str[3]
  packetType=str[4]
  seq=str[10]
  data = {}
  data.typeId=typeId
  data.time=time
  data.source=source
  data.dest=dest
  data.seq=seq
  data.packetType=packetType
  vegas.push(data)
});

var lineReaderTahoe = require('readline').createInterface({
  input: require('fs').createReadStream('tahoe.tr')
});

tahoe=[]

lineReaderTahoe.on('line', function (line) {
  str = line.split(" ");
  typeId=str[0]
  time =str[1]
  source=str[2]
  dest=str[3]
  packetType=str[4]
  seq=str[10]
  data = {}
  data.typeId=typeId
  data.time=time
  data.source=source
  data.dest=dest
  data.seq=seq
  data.packetType=packetType
  tahoe.push(data)
});

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'))
var port = process.env.PORT || 8080;

var router = express.Router();              // get an instance of the express Router

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/reno', function(req, res) {
    res.json({ reno:reno });   
});

router.get('/vegas', function(req, res) {
    res.json({ vegas:vegas });   
});

router.get('/tahoe', function(req, res) {
    res.json({ tahoe:tahoe });   
});

router.get('/', function(req, res) {
    res.json({ reno:reno });   
});

app.use('/api', router);

app.listen(port);
console.log('Magic happens on port ' + port);