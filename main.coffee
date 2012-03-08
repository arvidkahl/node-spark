# Configuration Files
config = require './config.coffee'

# Requires and Variables
exp = require 'express'
app = exp.createServer()

coffee = require 'coffee-script'
less = require 'less'
fs = require 'fs'
md = require('node-markdown').Markdown
auth = require './auth.coffee'

# Session perstistence implemented with CouchDB
sessionDB = require('connect-couchdb')(exp)

# App Configuration
app.configure () ->
	app.set 'view engine', 'jade'
	app.set 'views', __dirname + '/views'
	app.use exp.errorHandler { dumpExceptions: true, showStack: true }
	app.use exp.methodOverride()
	app.use exp.bodyParser()
	app.use exp.cookieParser()
	app.use exp.session {secret: 'nawollenwirdochmalsehn', store: new sessionDB({host: config.sessionDBHost,name: config.sessionDBName,  reapInterval: 600000, compactInterval: 300000})}
	app.use exp.compiler { src: __dirname + '/public', dest: __dirname + '/public', enable: ['less'] }
	app.use exp.static __dirname + '/public'	
	app.use auth.middleware()

auth.helpExpress app

# Articler Class
Articler = require('./articler.coffee').Articler
article = new Articler config.mainDBHost, config.mainDBPort, config.mainDB

app.get '/', (req, res) ->
	article.findAll (err, docs) ->
		res.render 'index', {
			locals: {
				title: 'Spark.'
				articles: docs
			}
		}
	
app.get '/new', (req, res) ->
	res.render 'new', {locals:{title:'Spark.'}}	

app.post '/new', (req, res) ->
	article.save {
        title: req.param 'title'
        body: req.param 'body'
        url: req.param 'url'
        created_at: new Date()
    }, (err, docs) ->
        res.redirect('/')

app.get '/concept', (req, res) ->
	fs.readFile 'CONCEPT.md', 'ascii', (err, data) ->
		throw err if err
		res.end md data
		
app.get '/:id', (req, res) ->
	article.findById req.params.id, (err, doc) ->
		if doc 
			res.render 'single', {
				locals:{
					title:"Spark.",
					doc: doc.value
				}
			}
		else
			res.redirect('/')
			
# Run App
app.listen 14904
console.log 'Server running at http://localhost:14904/'