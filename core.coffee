express = require 'express'
webserver = express()

util = require 'util' 
format = util.format    

racksjs = require('./racks.js')

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
	new racksjs ({username: req.body.name, apiKey: req.body.apiKey, verbosity: 5}), (rack) =>
		console.log 'rackspace auth successful'
		response = {}
		counter = 0
		products = {}
		for productName, product of rack.products
		#	#console.log "productName", productName, "product", product
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
					products[productName].resources[resourceName] = 
						modelFeatures: modelFeatures
						resourceFeatures: Object.keys(rack[productName][resourceName])
						models: []
		console.log 'sending:', products
		res.send(products)

# Start Server
webserver.listen(3000)
console.log('Listening on port 3000')

