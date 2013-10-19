var EventModel = function() {
    var self = this;

    self.handler = null;

    return {
        handle: function(event) {
            self.handler(event);
        },

        subscribe: function(screenType, screenId, handler) {
            // TODO sent subscription event
            self.handler = handler;
        },

        raise: function(event) {
            Socket.send(event);
        }
    };
}();
