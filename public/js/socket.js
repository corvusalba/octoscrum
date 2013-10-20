var Socket = function(endpoint) {
    var self = this;

    self.connection = null;

    var itemToJs = function(item) {
        var i = ko.toJS(item);
        delete i.children;
        return i;
    }

    var itemFromJs = function(item) {
        var i = ko.mapping.fromJS(data);
        i.children = ko.observableArray();
        return i;
    }

    return {
        onmessage: function(e) {
            var event = JSON.parse(e);
            if (event.data != null) {
                event.data = event.data.map(function(item) {
                    return itemFromJson(item);
                });
            }
            EventModel.handle(event);
        },

        init: function(endpoint) {
            self.connection = new WebSocket(endpoint);

            self.connection.onopen = function () {
                console.log("Opened.");
            };

            self.connection.onclose = function () {
                console.log("Closed.");
            };

            self.connection.onerror = function (error) {
                console.log("Error: " + error);
            };

            self.connection.onmessage = function(e) {
                self.onmessage(e);
            };
        },

        send: function(event) {
            if (event.data != null) {
                event.data = event.data.map(function (item) {
                    return itemToJs(item);
                });
            }
            self.connection.send(JSON.stringify(event));
        }
    };
}();

$(function() {
    pathArray = window.location.href.split('/');
    protocol = pathArray[0];
    host = pathArray[2].split(':')[0];
    url = 'ws://' + host + ":8081";
    Socket.init(url);
});
