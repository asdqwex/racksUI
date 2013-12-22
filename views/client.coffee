client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.user.name = ""
	$scope.user.apiKey = ""
	$scope.getAccount = (user) ->
		$scope.toggle = 0
		$http.post('/getAccount', user).success (resp) =>
			$scope.palettes = resp
			console.log resp 
		console.log user
	$scope.resourceClick = (productName,resourceName, feature, data) ->
		$http.post('/'+productName+'/'+resourceName+'/'+feature, data).success (resp) =>
				console.log resp