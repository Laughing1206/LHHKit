(function() {

var container = document.getElementById('container')

var template = _.unescape(container.innerHTML)

var compiled = _.template(template)

if ( json.error ) {
    json.error.isHTML = false;
    if ( json.error.body ) {
        var err = json.error.body
        if (err != null) {
            // Try to find html
            if ( -1 != err.indexOf('<html') && -1 != err.indexOf('</html>') ) {
                json.error.isHTML = true;
            }
        }
    }
} 

var __ = {
    "print": function (obj) {
        if ( _.isObject(obj) ) {
            return JSON.stringify(obj, null, "   ")
        } else {
            return obj
        }
    }
}

var options = {'api':json, '_': _, '__': __}

container.innerHTML = compiled(options)

hljs.initHighlightingOnLoad()

}.call(this))