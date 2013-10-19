var Socket = function(endpoint) {
    var self = this;

    self.connection = null;

    connection.onopen = function () {
        console.log("Opened.");
    };

    connection.onclose = function () {
        console.log("Closed.");
    };

    connection.onerror = function (error) {
        console.log("Error: " + error);
    };

    connection.onmessage = function(e) {
        EventModel.handle(JSON.parse(e.data));
    };

    return {
        init: function(endpoint) {
            self.connection = new WebSocket(endpoint);
        },

        send: function(event) {
            self.connection.send(JSON.stringify(event));
        }
    };
}();

$(function() {
    Socket.init('http://localhost:8081/');
});
