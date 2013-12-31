express = require 'express'
webserver = express()

util = require 'util' 
format = util.format    

racksjs = require('./racks.js')
rack = false

#express config
webserver.engine 'html', require('ejs').renderFile
webserver.use(express.bodyParser());
#set public docroot
webserver.use "/views", express.static(__dirname + '/views')

# Auth with Rackspace API
rackAuth = (cb) ->
	if rack
		cb() 
	else
		# for dev mode, use auth passed in from args -> THIS MEANS ANYONE USING THE SITE WILL USE THIS API KEY -> SO DEV MODE ONLY
		new racksjs {username: process.argv[2], apiKey: process.argv[3], verbosity: 5, cache:  false}, (newRack) =>
		# This is to use the string passed in from the /getAccount route - ie: production mode
		# new racksjs {username: req.body.name, apiKey: req.body.apiKey, verbosity: 0, cache: true}, (newRack) =>
			if rack.error
				console.log rack.error
				return res.send rack.error
			rack = newRack;
			cb()

webserver.get '/', (req, res) =>
	res.render 'index.html', (err, html) =>
		if err
			console.log err
			res.send err
		else
			console.log 'index rendered'
			res.send html

webserver.post '/getAccount', (req, res) =>
	rackAuth () =>
		console.log 'rackspace auth successful', req.body
		response = {}
		counter = 0
		products = {}
		for productName, product of rack.products
			#console.log "productName", productName, "product", product
			products[productName] = {
				productFeatures: []
				resources: {}
				meta: {
					target: rack[productName].meta.target(),
					endpoints: rack[productName].meta.endpoints
				}
			}
			for resourceName, resource of rack.products[productName]
				counter++
				if typeof resource == 'function'
					products[productName].productFeatures.push(resourceName)
				else
					if !rack[productName][resourceName].model?
						modelFeatures = []
					else
						modelFeatures = Object.keys(rack[productName][resourceName].model({}))
					resourceFeatures = {}
					filteredResourceFeatures = ['assume', 'meta', 'model']
					for featureName, feature of rack[productName][resourceName]
						if featureName in filteredResourceFeatures
							#console.log 'feature filtered:', featureName
						else
							featureObject = {}
							featureObject = {
								show: 0
								details: feature
								request: {}
							}
							resourceFeatures[featureName] = featureObject
					#console.log resourceFeatures
					products[productName].resources[resourceName] = 
						modelFeatures: modelFeatures
						resourceFeatures: resourceFeatures
						models: []
						meta: rack[productName][resourceName].meta
		res.send(products)
webserver.post '/resources/:productName/:resourceName/:feature', (req, res) =>
	if rack
		if typeof rack[req.params.productName][req.params.resourceName][req.params.feature] == 'function'
			rack[req.params.productName][req.params.resourceName][req.params.feature] (reply) ->
				res.send reply
		else
			console.log('REQUESTED FEATURE WAS NOT A FUNCTION:', req.params)
			res.send []
	else
		console.log 'please auth'
		res.send []

webserver.post '/actions/:modelName/:modelAction', (req, res) =>
	#console.log 'action:',req.body.action
	#console.log 'id:', req.body.id
	action = req.body.action
	assumeObject = {
		id: req.body.id
	}
	rack.cloudServersOpenStack.servers.assume assumeObject , (reply) =>
		#console.log res
		reply.details (reply) =>
			console.log reply.server
			res.send reply.server

# Start Server
webserver.listen(3000)
console.log('Listening on port 3000')

