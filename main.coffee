# Requires and Variables
exp = require 'express'
app = exp.createServer()
 
# App Configuration
app.configure () ->
    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'
    app.use exp.static __dirname + '/public'
    app.use exp.methodOverride()
	app.use exp.bodyParser()
 
# Articler Class
Articler = require('./articler').Articler
article = new Articler 'http://arvidkahl.iriscouch.com', 5984

app.get '/', (req, res) ->
	article.findAll (err, docs) ->
		console.log "GET /"
		res.render 'index', {
			locals: {
				title: 'Sparks'
				articles: docs
			}
		}
	
app.get '/new', (req, res) ->
	console.log "GET /new"
	res.render 'new', {locals: {title: 'Sparks / New Post'}}	

app.post '/new', (req, res) ->
	console.log "POST /new"
	console.log req.param 'title'
	article.save {
        title: req.param 'title'
        body: req.param 'body'
        created_at: new Date()
    }, (err, docs) ->
        res.redirect('/')

# Run App
app.listen 14904
console.log 'Server running at http://localhost:14904/'