var ProjectViewModel = function() {
    var self = this;

    self.iterations = ko.observableArray();

    self.getIteration = function(id) {
        return ko.utils.arrayFirst(self.iterations(), function(iteration) {
            return iteration.id() === id;
        });
    }

    self.getIsuue = function(parent, id) {
        var iteration = self.getIteration(parent);
        if (iteration === null)
            return;
        return ko.utils.arrayFirst(iteration.children(), function(issue) {
            return issue.id() === id;
        });
    }

    self.onadd = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration") {
                self.iterations.push(item);
            }
            if (item.type() === "bug" || item.type() === "feature") {
                var iteration = self.getIteration(item["id"]);
                if (iteration != null) {
                    iteration.children.push(item);
                }
            }
        });
    }

    self.onupdated = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration") {
                var iteration = self.getIteration(item.id());
                if (iteration != null)
                {
                    updateIteration(iteration, item)
                }
            }
            if (item.type() === "bug" || item.type() == "feature") {
                var issue = self.getIssue(item.parent(), item.id());
                if (issue != null) {
                    updateIssue(issue, item);
                }
            }
        });
    }

    self.onremoved = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration" and item.id() != "-1") {
                var iteration = self.getIteration(item.id());
                if (iteration != null)
                {
                    self.iterations.remove(iteration);
                }
            }
            if (item.type() === "bug" || item.type() === "feature") {
                var issue = self.getIssue(item.parent(), item.id());
                if (issue != null) {
                    self.getIteration(item.parent()).children.remove(issue);
                }
            }
        });
    }

    self.populate = function(data) {
        // TODO Add "unassigned" iteration
        self.iterations([]);
        self.onadd(data);
    }

    self.handle = function(event) {
        if (event["eventType"] == "subscribed") {
            self.populate(event["data"]);
        }
        if (event["eventType"] == "added") {
            self.onadded(event["data"]);
        }
        if (event["eventType"] == "updated") {
            self.onupdated(event["data"]);
        }
        if (event["eventType"] == "removed") {
            self.onremoved(event["data"]);
        }
    }

    self.addItem = function(item) {
        EventModel.raise("add", "project", getScreenId(), [ item ]);
    }

    self.updateItem = function(item) {
        EventModel.raise("update", "project", getScreenId(), [ item ]);
    }

    self.removeItem function(item) {
        EventModel.raise("remove", "project", getScreenId(), [ item ]);
    }

    self.init = function()
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
