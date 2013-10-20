var PlanningViewModel = function() {
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
        EventModel.subscribe("repositary", getScreenId(), self.handle);
    }
};

var planningViewModel = null;

$(function () {
    planningViewModel = new PlanningViewModel();
    planningViewModel.init();
    ko.applyBindings(planningViewModel);
});
