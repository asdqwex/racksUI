client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.user.name = "xqweasdx"
	$scope.user.apiKey = "76381a8f3b714a02be3b944a21f435d4"
	$scope.getAccount = (user) ->
		$scope.toggle = 0
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			console.log resp 
		console.log user
	$scope.resourceClick = (productName,resourceName, feature, data) ->
		$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show = !$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show
		console.log resp
	$scope.resourceSubmit = () =>
		#$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
		#		$scope.palettes[productName].models = resp
		#