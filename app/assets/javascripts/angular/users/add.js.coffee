app.controller 'UserAddCtrl', ['$scope', '$uibModalInstance', ($scope, $uibModalInstance)->
  $scope.user = {}
  $scope.error = false

  $scope.ok = ()->
    if $scope.user == null || $scope.user.login == null || $scope.user.first_name == null || $scope.user.last_name == null || $scope.user.key == null
      $scope.error = true
      return

    $uibModalInstance.close($scope.user)

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');
]
