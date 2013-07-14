 var express = require('express'),
  http = require('http'),
  connect = require('connect'),
  sio = require('socket.io');

var saticServer = connect()
  .use(connect.static('public'))
  .use(connect.directory('public'))
  .use(connect.cookieParser());

var app = express();

app.configure( function(){
  app.use(saticServer);
  app.use(express.errorHandler());
  app.use(express.bodyParser());
});

var server = http.createServer(app);

var io = sio.listen(server,  { log: false });

server.listen(process.argv[2] || 80);

io.sockets.on('connection', function(socket){
  socket.on('stroke', function(d){
    if(d && d.r && d.g && d.b && d.rad && d.x && d.y)
      socket.broadcast.emit('stroke', d);
  });
});