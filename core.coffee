express = require 'express'
webserver = express()

#mongo = require 'mongodb'
#database = mongo.MongoClient

util = require 'util' 
format = util.format    

racksjs = require('./racks.js')

#express config
webserver.engine 'html', require('ejs').renderFile
webserver.use(express.bodyParser());

#set public docroot
webserver.use "/views", express.static(__dirname + '/views')

#Routes
#######
#template
#	doplr.verb '/', (req, res) =>
#		console.log err
#		res.send resp
#################################
#DB operations
##############
#	database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#		collection = db.collection('devices')
#		resp = collection.find().toArray( (err, results) =>
#				res.send results
#			)
#	db.close()

webserver.get '/', (req, res) =>
	res.render 'index.html', (err, html) =>
		if err
			console.log err
			res.send err
		else
			console.log 'index rendered'
			res.send html

webserver.post '/getAccount', (req, res) =>
	console.log req.body
	new racksjs ({username: req.body.name, apiKey: req.body.apiKey, verbosity: 5}), (rack) =>
		console.log 'rackspace auth successful'
		response = {}
		counter = 0
		for productName, product of rack.products
			response[productName] = []
			for resourceName, resource of rack.products[productName]
				counter++
				rack.products[productName][resourceName].all (reply) =>
					console.log reply
					#counter--
					#response[productName].push(reply)
					#if counter == 0
					#	console.log response
					#	res.send response







#
#OLD
#
#doplr.get '/getDevices', (req, res) =>
#	console.log 'getDevices route reached'
#	database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#		collection = db.collection('devices')
#		collection.find().toArray (err, results) =>
#			if err
#				console.log err
#				res.send err
#			else
#				console.log 'success'
#				res.send results
#			db.close()
#			
#
#doplr.get '/getAccounts', (req, res) =>
#	console.log 'getAccounts route reached'
#	database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#		collection = db.collection('accounts')
#		collection.find().toArray (err, results) =>
#			if err
#				console.log err
#				res.send err
#			else
#				console.log 'success'
#				res.send results
#			db.close()
#			
#
#doplr.post '/createDevice', (req, res) =>
#	console.log 'createDevice route reached'
#	database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#		collection = db.collection('devices')
#		collection.save req.body, (err, results) =>
#			if err
#				console.log err
#				res.send err
#			else
#				console.log 'success'
#				res.send results
#			db.close()
#			
#doplr.post '/createAccount', (req, res) =>
#	console.log 'createAccount route reached'
#	database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#		collection = db.collection('accounts')
#		collection.save req.body, (err, results) =>
#			if err
#				console.log err
#				res.send err
#			else
#				console.log 'success'
#				res.send results
#			db.close()
#
#doplr.post '/syncAccount', (req, res) =>
#	console.log 'syncAccount route reached'
#	authObj = { 
#		username: req.body.username,
#		apiKey: req.body.apiKey
#	}
#	rax = new RaxJS authObj , () =>
#		rax.cloudServersOpenStack.servers.all (servers) =>
#			servers.forEach (server) =>
#				server.details (details) =>
#					console.log details
#					device = {
#						_id: server.id,
#						name: server.name,
#						ipaddress: details.accessIPv4
#					}
#					deviceArray = []
#					deviceArray.push(device)
#					res.send deviceArray
#					database.connect 'mongodb://127.0.0.1:27017/test', (err, db) =>
#						collection = db.collection('devices')
#						collection.save device, (err, results) =>
#							if err
#								console.log err
#								res.send err
#							else
#								console.log results
#							db.close()

# Start Server
webserver.listen(3000)
console.log('Listening on port 3000')

