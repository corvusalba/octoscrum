var EventModel = function() {
    var self = this;

    self.handler = null;

    return {
        handle: function(event) {
            self.handler(event);
        },

        subscribe: function(screenType, screenId, handler) {
            self.handler = handler;
            self.raise({
                eventType: "subscribe",
                screentType: screenType,
                screenId: screenId,
                data: null
            })
        },

        raise: function(event) {
            Socket.send(event);
        }
    };
}();
