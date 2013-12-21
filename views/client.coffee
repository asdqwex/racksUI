client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = {}
	$scope.user = {}
	$scope.toggle = 1
	$scope.user.name = "xqweasdx"
	$scope.user.apiKey = "73e313322c8f492cae6ff0f3efd897fe"
	$scope.getAccount = (user) ->
		$scope.toggle = 0
		$http.post('/getAccount', user).success( (resp) =>
			$scope.palettes = resp
			console.log resp 
			#for product of resp
			#	console.log product, resp[product]
			#	palette = {}
			#	palette.name = product
			#	palette.data = resp[product]
			#	#console.log palette
			#	$scope.palettes.push(palette)
			#console.log $scope.palettes
			)
		console.log user