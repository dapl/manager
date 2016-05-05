app.factory 'User', ['$resource', 'toaster', 'railsResourceFactory',
  ($resource, toaster, railsResourceFactory) ->
    r = railsResourceFactory
      url: '/users',
      name: 'user',
      updateMethod: 'put'

    r.myHandleSuccess = (data)->
      if data.success
        toaster.pop('success', 'Updated', data.message)
      else
        toaster.pop('error', 'Failed', data.message||data.error)

    r.myHandleError = (data)->
      console.debug data
      toaster.pop('error', 'Server', data.statusText)

    r.disable = (login)->
      r.$post(this.$url("#{login}/disable"))
      .then r.myHandleSuccess, r.myHandleError

    r.enable = (login)->
      r.$post(this.$url("#{login}/enable"))
      .then r.myHandleSuccess, r.myHandleError

    r.groupAdd = (login, group)->
      r.$post(this.$url("#{login}/groups?group=#{group}"))
      .then r.myHandleSuccess, r.myHandleError

    r.groupRemove = (login, group)->
      r.$delete(this.$url("#{login}/groups/#{group}"))
      .then r.myHandleSuccess, r.myHandleError

    r.keyAdd = (login, key)->
      r.$post(this.$url("#{login}/keys"), {key: key})
      .then r.myHandleSuccess, r.myHandleError

    r.keyRemove = (login, key_name)->
      r.$delete(this.$url("#{login}/keys/#{key_name}"))
      .then r.myHandleSuccess, r.myHandleError

    r.passwordChange = (login, password, confirmation)->
      r.$post(this.$url("#{login}/password"), {password: password, confirmation: confirmation})
      .then r.myHandleSuccess, r.myHandleError

    return r
]
