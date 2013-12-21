client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.palettes = []
	$scope.getAccount = (user) ->
		$http.post('/getAccount', user).success( (resp) =>
			for product of resp
				#console.log product, resp[product]
				palette = {}
				palette.name = product
				palette.data = resp[product]
				#console.log palette
				$scope.palettes.push(palette)
			#console.log $scope.palettes
			)
		console.log user