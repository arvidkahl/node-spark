(function() {
  var Articler, cradle;

  cradle = require('cradle');

  Articler = (function() {

    function Articler(host, port) {
      this.connect = new cradle.Connection(host, port, {
        cache: true,
        raw: false
      });
      this.db = this.connect.database('sparks');
    }

    Articler.prototype.findAll = function(callback) {
      return this.db.view('sparks/all', {
        descending: true
      }, function(err, res) {
        var docs;
        if (err) {
          return callback(err);
        } else {
          docs = [];
          res.forEach(function(row) {
            return docs.push(row);
          });
          return callback(null, docs);
        }
      });
    };

    Articler.prototype.save = function(articles, callback) {
      return this.db.save(articles, function(err, res) {
        if (err) {
          return callback(err);
        } else {
          return callback(null, articles);
        }
      });
    };

    return Articler;

  })();

  exports.Articler = Articler;

}).call(this);
