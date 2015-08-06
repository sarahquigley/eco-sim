angular.module('EcoSim', [
])

.factory('_', -> _)

.factory('Creature', -> Creature)

.factory('Ecosystem', -> Ecosystem)

.controller('EcoSimCtrl',
['$scope', '$interval', '_', 'Ecosystem',
($scope, $interval, _, Ecosystem) ->
  $scope.ecosystem = new Ecosystem()

  $scope.creature_types = {
    'green': {type: 'green'},
    'blue': {type: 'blue', prey: 'green'},
    'red': {type: 'red', prey: 'blue'}
  }

  $scope.creature_type = $scope.creature_types.green

  $scope.add_creature = (event) ->
    position = {
      x: event.x - event.srcElement.offsetLeft + window.scrollX,
      y: event.y - event.srcElement.offsetTop + window.scrollY,
    }
    creature = $scope.ecosystem.add_creature(position, $scope.creature_type.type, $scope.creature_type.prey)

  $scope.start = () ->
    $scope.interval = $interval($scope.ecosystem.run, 10)

  $scope.stop = () ->
    if angular.isDefined($scope.interval)
      $interval.cancel($scope.interval)

  $scope.reset = () ->
    $scope.stop()
    $scope.ecosystem = new Ecosystem()

  window.ecosystem = $scope.ecosystem
])
