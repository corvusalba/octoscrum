var EventModel = function() {
    var self = this;

    return {
        handle: function(event) {
            self.handler(event);
        },

        subscribe: function(screenType, screenId, handler) {
            self.handler = handler;
            EventModel.raise("subscribe", screenType, screenId, null);
        },

        raise: function(eventType, screenType, screenId, data) {
            Socket.send({
                eventType: eventType,
                screenType: screenType,
                screenId: screenId,
                data: data
            });
        };
    };
}();
