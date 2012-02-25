(function() {
  var Articler, app, article, exp;

  exp = require('express');

  app = exp.createServer();

  app.configure(function() {
    app.set('view engine', 'jade');
    app.set('views', __dirname + '/views');
    app.use(exp.static(__dirname + '/public'));
    return app.use(exp.methodOverride());
  });

  app.use(exp.bodyParser());

  Articler = require('./articler').Articler;

  article = new Articler('http://arvidkahl.iriscouch.com', 5984);

  app.get('/', function(req, res) {
    return article.findAll(function(err, docs) {
      console.log("GET /");
      return res.render('index', {
        locals: {
          title: 'Sparks',
          articles: docs
        }
      });
    });
  });

  app.get('/new', function(req, res) {
    console.log("GET /new");
    return res.render('new', {
      locals: {
        title: 'Sparks / New Post'
      }
    });
  });

  app.post('/new', function(req, res) {
    console.log("POST /new");
    console.log(req.param('title'));
    return article.save({
      title: req.param('title'),
      body: req.param('body'),
      created_at: new Date()
    }, function(err, docs) {
      return res.redirect('/');
    });
  });

  app.listen(14904);

  console.log('Server running at http://localhost:14904/');

}).call(this);
