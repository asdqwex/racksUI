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
	new racksjs ({username: req.body.name, apiKey: req.body.apiKey, verbosity: 0}), (newRack) =>
		rack = newRack
		if rack.error
			console.log rack.error
			res.send rack.error
			return false
		console.log 'rackspace auth successful'
		response = {}
		counter = 0
		products = {}
		for productName, product of rack.products
			#console.log "productName", productName, "product", product
			products[productName] = {
				productFeatures: []
				resources: {}
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
					for featureName, feature of rack[productName][resourceName]
						featureObject = {}
						featureObject = {
							show: 0
							details: feature
						}
						resourceFeatures[featureName] = featureObject
					console.log resourceFeatures
					# Filter out unbuttomizable features manually .... QQ
					#resourceFeatures.splice(resourceFeatures.indexOf('meta'), 1) if resourceFeatures.indexOf('meta') > -1
					#resourceFeatures.splice(resourceFeatures.indexOf('model'), 1) if resourceFeatures.indexOf('model') > -1
					#resourceFeatures.splice(resourceFeatures.indexOf('assume'), 1) if resourceFeatures.indexOf('assume') > -1


					products[productName].resources[resourceName] = 
						modelFeatures: modelFeatures
						resourceFeatures: resourceFeatures
						models: []
		console.log 'sending:', products
		res.send(products)
webserver.post '/:productName/:resourceName/:feature', (req, res) =>
	if rack
		if typeof rack[req.params.productName][req.params.resourceName][req.params.feature] == 'function'
			rack[req.params.productName][req.params.resourceName][req.params.feature] (reply) ->
				console.log reply
				res.send reply
	else
		console.log 'please auth'

	console.log req.body
	console.log req.args, req.params

# Start Server
webserver.listen(3000)
console.log('Listening on port 3000')

