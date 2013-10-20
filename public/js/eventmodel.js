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
                login: getLogin(),
                token: getToken(),
                eventType: eventType,
                screenType: screenType,
                screenId: screenId,
                data: data
            });
        };
    };
}();
