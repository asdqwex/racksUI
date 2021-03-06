// Generated by CoffeeScript 1.6.3
(function() {
  var client,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  client = angular.module('client', []);

  client.controller('MainCtrl', function($scope, $http) {
    var _this = this;
    $scope.palettes = {};
    $scope.request = {};
    $scope.user = {};
    $scope.toggle = 1;
    $scope.flavors = {};
    $scope.images = {};
    $scope.actions = {};
    $scope.prettyPalettes = "";
    $scope.getAccount = function(user) {
      var _this = this;
      $scope.toggle = !$scope.toggle;
      return $http.post('/getAccount', user).success(function(resp) {
        var feature, featureName, product, productName, resource, resourceName, _ref, _ref1, _ref2;
        $scope.palettes = resp;
        _ref = $scope.palettes;
        for (productName in _ref) {
          product = _ref[productName];
          _ref1 = product.resources;
          for (resourceName in _ref1) {
            resource = _ref1[resourceName];
            _ref2 = resource.resourceFeatures;
            for (featureName in _ref2) {
              feature = _ref2[featureName];
              feature.show = 0;
            }
          }
        }
        $http.get('/resources/cloudServersOpenStack/flavors/all').success(function(resp) {
          return $scope.flavors = resp;
        });
        return $http.get('/resources/cloudServersOpenStack/images/all').success(function(resp) {
          return $scope.images = resp;
        });
      });
    };
    $scope.getAccount({
      username: 'dummy',
      apiKey: 'dummy'
    });
    $scope.inputlessFeatures = ['all'];
    $scope.resourceClick = function(productName, resourceName, feature) {
      var _this = this;
      if (__indexOf.call($scope.inputlessFeatures, feature) >= 0) {
        return $http.get('/resources/' + productName + '/' + resourceName + '/' + feature).success(function(resp) {
          if (resp.length === 0) {
            resp = [
              {
                name: 'No results'
              }
            ];
          }
          $scope.palettes[productName].resources[resourceName].models = resp;
          return $scope.palettes[productName].resources[resourceName].showModels = !$scope.palettes[productName].resources[resourceName].showModel;
        });
      } else {
        return $scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show = !$scope.palettes[productName].resources[resourceName].resourceFeatures[feature].show;
      }
    };
    $scope.formSubmit = function(formData) {
      var reqData;
      formData.show = !formData.show;
      reqData = {
        name: formData.name,
        flavorRef: formData.flavor.id,
        imageRef: formData.image.id
      };
      console.log(reqData);
      return $http.post('/resources/cloudServersOpenStack/servers/new', reqData).success(function(resp) {
        return console.log(resp);
      });
    };
    $scope.serverFormCheck = function(productName) {
      if (productName === 'cloudServersOpenStack') {
        return true;
      } else {
        return false;
      }
    };
    $scope.modelAction = function(productName, resourceName, Modelaction, model) {
      var data;
      model.action = {};
      model.action.show = !model.action.show;
      data = {
        product: productName,
        resource: resourceName,
        id: model.id,
        action: Modelaction
      };
      return $http.post('/actions/' + model.id + '/' + Modelaction, data).success(function(resp) {
        model.action.output = angular.toJson(resp, true);
        return console.log('model', model.action.output);
      });
    };
    $scope.prettyify = function() {
      return $scope.prettyPalettes = angular.toJson($scope.palettes, true);
    };
    return $scope.featureFilter = function(items) {
      var result;
      result = [];
      angular.forEach(items, function(value, key) {
        return result.push(key);
      });
      return result;
    };
  });

}).call(this);
