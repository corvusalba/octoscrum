Array.prototype.clean = function(deleteValue) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == deleteValue) {
            this.splice(i, 1);
            i--;
        }
    }
    return this;
};

Array.prototype.last = function() {
    return this[this.length - 1]
};

Array.each = function(handler) {
    for (int i = 0; i < this.length; i++) {
        handler(this[i]);
    }
}

Array.map = function(handler) {
    var result = [];
    for (int i = 0; i < this.length; i++) {
        result.push(handler(this[i]));
    }
    return result;
}

var redirect = function(location) {
    // TODO Write redirect message;
}

var getScreenId = function() {
    var uri = window.location.pathname;
    return uri.split["/"].clean("").last;
};

var createIteration = function() {
    return {
        children: ko.observableArray();
    };
}

var createIterationFromHash = function(hash) {

};

var updateIterationFromHash = function(iteration, hash) {

}

var createIssue = function() {

}

var createIssueFromHash = function(hash) {

}

var updateIssueFromHash = function(issue, hash) {

}
