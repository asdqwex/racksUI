client = angular.module('client', [])
 
client.controller 'MainCtrl', ($scope, $http) ->
	$scope.paletteList = []
	$scope.getAccount = (user) ->
		$http.post('/getAccount', user).success( (resp) =>
			console.log resp
			for device in resp
				$scope.paletteList.push(device)
			)
		console.log user