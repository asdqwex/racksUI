client = angular.module('client', [])

client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.request = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.flavors = {}
	$scope.images = {}
	$scope.actions = {}
	$scope.getAccount = (user) ->
		$scope.toggle = !$scope.toggle
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			for productName, product of $scope.palettes
				for resourceName, resource of product.resources
					for featureName, feature of resource.resourceFeatures
						feature.show = 0
			$http.get('/resources/cloudServersOpenStack/flavors/all').success (resp) =>
				$scope.flavors = resp
			$http.get('/resources/cloudServersOpenStack/images/all').success (resp) =>
				$scope.images = resp

	# FOR DEV MODE ONLY
	$scope.getAccount({ username: 'dummy', apiKey: 'dummy' });

	$scope.inputlessFeatures = ['all']
	$scope.resourceClick = (productName,resourceName, feature) ->
		if feature in $scope.inputlessFeatures
			$http.get('/resources/'+productName+'/'+resourceName+'/'+feature).success (resp) =>
				resp = [ { name: 'No results' } ] if resp.length == 0
				$scope.palettes[productName].resources[resourceName].models = resp
		else
			console.log('feature:', feature);
			console.log 'meta', $scope.palettes[productName].resources[resourceName]
			$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show = !$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show
	#$scope.resourceSubmit = () =>
	#	$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
	#		resp = [ { name: 'No results' } ] if resp.length == 0
	#		$scope.palettes[productName].resources[resourceName].models = resp
	$scope.formSubmit = (formData) =>
		formData.show = !formData.show
		reqData = {
			name: formData.name
			flavorRef: formData.flavor.id
			imageRef: formData.image.id
		}
		console.log reqData
		$http.post('/resources/cloudServersOpenStack/servers/new', reqData).success (resp) =>
			 console.log resp
	$scope.serverFormCheck = (productName) =>
		if productName =='cloudServersOpenStack'
			return true
		else
			return false
	$scope.modelAction = (productName, resourceName, Modelaction, model) =>
		model.action = {}
		model.action.show = !model.action.show
		data = {
				product: productName
				resource: resourceName
				id: model.id,
				action: Modelaction
		}
		$http.post('/actions/'+model.id+'/'+Modelaction, data).success (resp) =>
			model.action.output = angular.toJson(resp, true)
			console.log 'model', model.action.output



		

		