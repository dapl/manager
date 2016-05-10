window.app = angular.module('Dapl', [
  'ngResource',
  'ngRoute',
  'ui.bootstrap',
  'toaster',
  'templates',
  'xeditable',
  'rails'
])

app.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode false
]

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .otherwise
    redirectTo: '/users/me'
]

app.factory 'Session', ['$rootScope', '$location', 'User', ($rootScope, $location, User)->
  _user = null
  _admin = false

  User.get('me').then (user)->
    _user = user
    _admin = user.groups && 'dapl' in user.groups # TODO: make this configurable

  path: (path, exact = false)->
    if exact
      $location.path() == path
    else
      $location.path().indexOf(path) == 0

  current: ()->
    _user

  admin: ()->
    _admin

  #  _view = 'grid'
  #  _filter = null
  #  _logs = []
  #  _messages = false
  #  view: (view)->
  #    if view
  #      _view = view
  #      $rootScope.$broadcast 'session:view', view
  #    _view
  #  logs: ()->
  #    _logs
  #  logger: (message)->
  #    _logs.push message
  #    $rootScope.$broadcast "logger:received", message
  #  messages: (set)->
  #    _messages = set
  #  hasMessages: ->
  #    _messages
  #  filter: (filter)->
  #    if filter
  #      _filter = filter
  #      $rootScope.$broadcast 'session:filter', filter
  #    _filter
  #  action: ()->
  #    $location.path()
]

#app.factory '$exceptionHandler', ['$log', ($log)->
#  (exception, cause)->
#    exception.message += ' (caused by "' + cause + '")';
#    $log.error cause
#    throw exception
#]

#angular.module('exceptionOverride', []).factory('$exceptionHandler', function() {
#return function(exception, cause) {
#  exception.message += ' (caused by "' + cause + '")';
#throw exception;
#};
#});

app.run ['editableOptions', (editableOptions)->
  editableOptions.theme = 'bs3' # 'bs3','bs2','default'
]
