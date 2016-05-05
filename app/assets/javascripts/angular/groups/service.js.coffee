app.factory 'Group', ['$resource', 'toaster', 'railsResourceFactory',
  ($resource, toaster, railsResourceFactory) ->
    r = railsResourceFactory
      url: '/groups',
      name: 'group',
      updateMethod: 'put'

    r.myHandleSuccess = (data)->
      if data.success
        toaster.pop('success', 'Updated', data.message)
      else
        toaster.pop('error', 'Failed', data.message||data.error)

    r.myHandleError = (data)->
      console.debug data
      toaster.pop('error', 'Server', data.statusText)

    r.userAdd = (group, user)->
      r.$post(this.$url("#{group}/users"), {user: user})
      .then r.myHandleSuccess, r.myHandleError

    r.userRemove = (group, user)->
      r.$delete(this.$url("#{group}/users/#{user}"))
      .then r.myHandleSuccess, r.myHandleError

    r
]
