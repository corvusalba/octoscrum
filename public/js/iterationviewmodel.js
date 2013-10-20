var IterationViewModel = function() {
    var self = this;

    self.populate = function(data) {

    }

    self.handle = function(event) {
        if (event["eventType"] == "subscribed") {
            self.populate(event["data"]);
        }
    }

    self.init = function ()
    {
        EventModel.subscribe("iteration", getScreenId(), self.handle);
    }
};

var IterationView = null;

$(function () {
    IterationView = new IterationViewModel();
    IterationView.init();
    ko.applyBindings(IterationView);
});
