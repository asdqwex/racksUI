client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.getAccount = (user) ->
		$scope.toggle = !$scope.toggle
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			for productName, product of $scope.palettes
				for resourceName, resource of product.resources
					for featureName, feature of resource.resourceFeatures
						feature.show = 0

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
	$scope.getModelDetails = () =>