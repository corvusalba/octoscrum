var Socket = function(endpoint) {
    var self = this;

    self.connection = null;

    var itemToJs = function(item) {
        var i = ko.toJS(item);
        delete i.children;
        return i;
    }

    var itemFromJs = function(item) {
        i.children = ko.observableArray();
        return i;
    }

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
        var event = JSON.parse(e);
        if (event.data != null) {
            event.data = event.data.map(function(item) {
                return itemFromJson(item);
            });
        }
        EventModel.handle(event);
    };

    return {
        init: function(endpoint) {
            self.connection = new WebSocket(endpoint);
        },

        send: function(event) {
            if (event.data != null) {
                event.data = event.data.map(function (item) {
                    return itemToJs(item);
                });
            };

            self.connection.send(JSON.stringify(event));
        }
    };
    ()};

$(function() {
    Socket.init('http://localhost:8081/');
});
