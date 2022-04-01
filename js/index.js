var ws = require('ws')
var server = new ws.Server({ port: 7523 })

server.on('connection', server => {
    server.on('message', message => {
        let data = JSON.parse(message);
        console.log(data);
    });
    server.on('close', (code, reason) => {
        console.log(code, reason);
    });
    server.send(JSON.stringify({ "teeeesr": "t" }));
});
