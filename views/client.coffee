client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.request = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.flavors = {}
	$scope.images = {}
	$scope.getAccount = (user) ->
		$scope.toggle = !$scope.toggle
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			for productName, product of $scope.palettes
				for resourceName, resource of product.resources
					for featureName, feature of resource.resourceFeatures
						feature.show = 0
			$http.post('/cloudServersOpenStack/flavors/all').success (resp) =>
				$scope.flavors = resp
			$http.post('/cloudServersOpenStack/images/all').success (resp) =>
				$scope.images = resp

	# FOR DEV MODE ONLY
	$scope.getAccount({ username: 'dummy', apiKey: 'dummy' });

	$scope.inputlessFeatures = ['all']
	$scope.resourceClick = (productName,resourceName, feature, data) ->
		if feature in $scope.inputlessFeatures
			$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
				resp = [ { name: 'No results' } ] if resp.length == 0
				$scope.palettes[productName].resources[resourceName].models = resp
		else
			console.log('feature:', feature);
			console.log 'meta', $scope.palettes[productName].resources[resourceName]
			$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show = !$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show
	$scope.resourceSubmit = () =>
		$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
			resp = [ { name: 'No results' } ] if resp.length == 0
			$scope.palettes[productName].resources[resourceName].models = resp
	$scope.formSubmit = (formData) =>
		formData.show = !formData.show
		console.log 'submit click'
		for fieldName, fieldValue of formData.request
			console.log 'request item', fieldName, fieldValue
	$scope.serverFormCheck = (productName) =>
		if productName =='cloudServersOpenStack'
			return true
		else
			return false

		