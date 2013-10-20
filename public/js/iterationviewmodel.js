var IterationViewModel = function() {
    var self = this;

    self.iteration = null;
    self.issues = ko.observableArray();

    self.getIsuue = function(parent, id) {
        return ko.utils.arrayFirst(issues(), function(issue) {
            return issue.id() === id;
        });
    }

    self.onadd = function(data) {
        data.each(function (item) {
            if (item.type() === "bug" || item.type() === "feature") {
                self.issues.push(item);
            }
        });
    }

    self.onupdated = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration") {
                if (self.iteration != null)
                {
                    updateIteration(self.iteration, item)
                }
            }
            if (item.type() === "bug" || item.type() === "feature") {
                var issue = self.getIssue(item.parent(), item.id());
                if (issue != null) {
                    updateIssue(issue, item);
                }
            }
        });
    }

    self.onremoved = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration" and item.id() === iteration.id()) {
                if (iteration != null)
                {
                    alert("Fuck! Some motherfucker delete your iteration!")
                    redirect('/');
                }
            }
            if (item.type() === "bug" || item.type() === "feature") {
                var issue = self.getIssue(item.parent(), item.id());
                if (issue != null) {
                    issues.remove(issue);
                }
            }
        });
    }

    self.populate = function(data) {
        data.each(function (item) {
            if (item.type() === "iteration") {
                self.iteration = item;
            }
        });
        self.([]);
        self.onadd(data);
    }

    self.handle = function (event) {
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

    self.addItem= function(item) {
        EventModel.raise("add", "iteration", getScreenId(), [ item ]);
    }

    self.updateItem = function(item) {
        EventModel.raise("update", "iteration", getScreenId(), [ item ]);
    }

    self.removeItem = function(item) {
        EventModel.raise("remove", "iteration", getScreenId(), [ item ]);
    }

    self.init = function()
    {
        EventModel.subscribe("iteration", getScreenId(), self.handle);
    };
}

var IterationView = null;

$(function () {
    IterationView = new IterationViewModel();
    IterationView.init();
    ko.applyBindings(IterationView);
});
