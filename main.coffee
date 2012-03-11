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
crypto = require 'crypto'

process.on 'uncaughtException', (err) ->
	console.log err.stack

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
	app.use exp.session {secret: 'nawollenwirdochmalsehn', store: new sessionDB({host: config.sessionDBHost,name: config.sessionDBName, auth: {username: config.sessionDBUser, password: config.sessionDBPass}, reapInterval: 600000, compactInterval: 300000})}
	app.use exp.compiler { src: __dirname + '/public', dest: __dirname + '/public', enable: ['less'] }
	app.use exp.static __dirname + '/public'	
	app.use auth.middleware()

auth.helpExpress app

# Articler Class
Articler = require('./articler.coffee').Articler
scene = new Articler config.mainDBHost, config.mainDBPort, config.mainDB

app.get '/', (req, res) ->
	scene.findAll (err, docs) ->
		res.render 'index', {
			locals: {
				title: 'Spark.'
				articles: docs
			}
		}

app.get '/scenes', (req, res) ->
	scene.findAll (err, docs) ->
		res.render 'scenes', {
			locals: {
				title: 'Spark.'
				articles: docs
			}
		}	
app.get '/new', (req, res) ->
	res.render 'new', {
		locals: {
			title: 'Spark.'
				}
			}	

app.post '/new', (req, res) ->
	if (req.session.auth.loggedIn)
		console.log req.session.auth
		uid = req.session.auth.userId
		scene.save {
			createUserId: uid
			createUserName: req.session.auth.twitter.user.name
			title: req.param 'title'
			body: req.param 'body'
			url: req.param 'url'
			found: req.param "found"
			creator: req.param "creator"
			created_at: new Date()
			stories: []
		}, (err, returnedDoc, returnedData) ->
			res.redirect('/'+returnedData.id)
	else res.redirect('/')

app.get '/concept', (req, res) ->
	fs.readFile 'CONCEPT.md', 'ascii', (err, data) ->
		throw err if err
		res.end md data

app.get '/random', (req, res) ->
	scene.findAllIds (err, ids) ->
		if err
			throw err
			res.redirect '/'
		else
			res.redirect '/'+ids[Math.floor(Math.random() * ids.length)].id
		
app.get '/:id', (req, res) ->
	scene.findById req.params.id, (err, doc) ->
		if doc 
			res.render 'single', {
				locals:{
					title:"Spark."
					id: req.params.id
					doc: doc.value
				}
			}
		else
			res.redirect('/')

app.get '/:id/edit', (req, res) ->
	scene.findById req.params.id, (err, doc) ->
		if doc
			console.log doc.value
			res.render 'edit', {
				locals:{
					title:"Spark."
					id: req.params.id
					doc: doc.value
				}
			}
		else
			res.redirect '/'
			
app.post '/:id/edit', (req, res) ->
	if (req.session.auth.loggedIn)
		scene.findById req.params.id, (err, doc) ->
			newStoryUserId = doc.value.createUserId
			if (newStoryUserId == req.session.auth.userId)
				newDoc = doc.value
				newDoc.title = req.param 'title'
				newDoc.url = req.param 'url'
				newDoc.body = req.param 'body'
				newDoc.found = req.param 'found'
				newDoc.creator = req.param 'creator'
				scene.saveById req.params.id, newDoc, (saveErr, saveDoc, saveRes) ->
					throw saveErr if saveErr
					res.redirect '/'+req.params.id
			else 
				res.redirect '/'+req.params.id
	else
		res.redirect '/'+req.params.id
	

app.post '/:id/delete', (req, res) ->
	storyId=req.params.id
	scene.findById storyId, (err, doc) ->
		if (req.session.auth.loggedIn)
			uid = req.session.auth.userId
			if (doc.value.createUserId == uid)
				scene.deleteById storyId, doc.value._rev, (deleteErr, deleteRes) ->
					throw deleteErr if deleteErr
		res.redirect '/'
		
app.post '/:id/add', (req, res) ->
	scene.findById req.params.id, (findErr, originalDoc) ->

		if originalDoc
			tempDoc = originalDoc.value
			uid = req.session.auth.userId
			
			newStory =  {
				title: req.param "title"
				story: req.param "story"
				createUserName: req.session.auth.twitter.user.name
				createUserId: uid
			}
			
			hash = crypto.createHmac('sha1', 'abcdeg').update(newStory.title+newStory.story+newStory.createUserId).digest('hex')
			
			newStory._id=hash
			
			tempDoc.stories.push newStory
			
			scene.saveById req.params.id, tempDoc, (saveErr, doc, saveRes) ->
				throw saveErr if saveErr
				res.redirect('/'+req.params.id)
		else
			console.log "could not retrieve original document"
			res.redirect('/'+req.params.id)

app.post '/:id/delete/:commentId', (req, res) ->
	console.log "finding..."
	scene.findById req.params.id, (err, doc) ->
		newStoryUserId = 'not authed'
		newStories = []
		stories = doc.value.stories
		stories.forEach (story) ->
			if (story._id != req.params.commentId)
				newStories.push story
			else
				newStoryUserId = story.createUserId
		doc.value.stories = newStories
		if (newStoryUserId == req.session.auth.userId)
			scene.saveById req.params.id, doc.value, (saveErr, saveDoc, saveRes) ->
				throw saveErr if saveErr
				res.notice = 'Saved.'
				res.redirect '/'+req.params.id
		else 
			res.redirect '/'+req.params.id
	

app.post '/:id/save/:commentId', (req, res) ->
	scene.findById req.params.id, (err, doc) ->
		newStoryUserId = 'not authed'
		newStories = []
		stories = doc.value.stories
		stories.forEach (story) ->
			if (story._id == req.params.commentId)
				story.title = req.param 'title'
				story.story = req.param 'story'
				newStoryUserId = story.createUserId
			newStories.push story
		doc.value.stories = newStories
		if (newStoryUserId == req.session.auth.userId)
			scene.saveById req.params.id, doc.value, (saveErr, saveDoc, saveRes) ->
				throw saveErr if saveErr
				res.redirect '/'+req.params.id
		else 
			res.redirect '/'+req.params.id
		
# Run App
app.listen 14904
console.log 'Server running at http://localhost:14904/'