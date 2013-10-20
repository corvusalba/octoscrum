var ProjectViewModel = function() {
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
        EventModel.subscribe("project", getScreenId(), self.handle);
    }
};

var ProjectView = null;

$(function () {
    ProjectView = new ProjectView();
    ProjectView.init();
    ko.applyBindings(ProjectView);
});
