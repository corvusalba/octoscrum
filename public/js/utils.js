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
};

Array.map = function(handler) {
    var result = [];
    for (int i = 0; i < this.length; i++) {
        result.push(handler(this[i]));
    }
    return result;
};

function getCookie(name) {
    var matches = document.cookie.match(new RegExp(
        "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ))
    return matches ? decodeURIComponent(matches[1]) : undefined
}


var getLogin = function() {
    return getCookie('login');
};

var getToken = function() {
    return getCookie('token');
}

var redirect = function(location) {
    document.location.href = location;
};

var getScreenId = function() {
    var uri = window.location.pathname;
    return uri.split["/"].clean("").last;
};

// TODO:

var createIteration = function() {
    return {
        children: ko.observableArray();
    };
}

var updateIteration = function(iteration, item) {

}

var createIssue = function() {

}

var updateIssue = function(issue, item) {

}
