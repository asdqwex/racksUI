client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.user = {}
	$scope.tmpToggle = 0
	$scope.toggle = 1
	$scope.user.name = ""
	$scope.user.apiKey = ""
	$scope.inputlessFeatures = ['all']
	$scope.getAccount = (user) ->
		$scope.toggle = !$scope.toggle
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			console.log resp 
		console.log user
	$scope.resourceClick = (productName,resourceName, feature, data) ->
		if feature in $scope.inputlessFeatures
			console.log 'feature input filtered', feature
			$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
				$scope.palettes[productName].models = resp
		else
			$scope.tmpToggle = !$scope.tmpToggle
			$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show = !$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show
	$scope.resourceSubmit = () =>
		$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
				$scope.palettes[productName].models = resp
	$scope.getModelDetails = () =>

		
