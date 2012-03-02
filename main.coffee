# Requires and Variables
exp = require 'express'
app = exp.createServer()

less = require 'less'
fs = require 'fs'
md = require('node-markdown').Markdown
auth = require 'auth'
#auth.helpExpress app

# App Configuration
app.configure () ->
	app.set 'view engine', 'jade'
	app.set 'views', __dirname + '/views'
	app.use exp.errorHandler { dumpExceptions: true, showStack: true }
	app.use exp.compiler { src: __dirname + '/public', dest: __dirname + '/public', enable: ['less'] }
	app.use exp.methodOverride()
	app.use exp.bodyParser()
	app.use exp.cookieParser()
	app.use exp.session {secret: 'nawollenwirdochmalsehn'}
	app.use exp.static __dirname + '/public'
	#app.use '/public/less' exp.static(__dirname + '/public/less')
	
	app.use auth.middleware()
 
#exp.compiler.compilers.less.compile = (str, fn) =>
#	less.render str, { compress : true }, fn	

# Articler Class
Articler = require('./articler').Articler
article = new Articler 'http://arvidkahl.iriscouch.com', 5984

app.get '/', (req, res) ->
	if (req.session.auth)		
		console.log "You are authed."
		#console.log req.session.auth.twitter
		user = req.session.auth.twitter.user
	else 
	    console.log "You are not authed."
	article.findAll (err, docs) ->
		console.log "GET /"
		res.render 'index', {
			locals: {
				title: 'Sparks'
				articles: docs
				user: user
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

app.get '/concept', (req, res) ->
	fs.readFile 'CONCEPT.md', 'ascii', (err, data) ->
		throw err if err
		res.end md data
		
# Run App
app.listen 14904
console.log 'Server running at http://localhost:14904/'