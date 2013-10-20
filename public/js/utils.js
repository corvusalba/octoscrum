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

var getScreenId = function() {
    var uri = window.location.pathname;
    return uri.split["/"].clean("").last;
};
