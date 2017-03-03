class UserStore
  data: {}
  subscribers: 0
  changeEvent: 'blundit:user'
  fetchMessagesTimeout: null
  lastMessagesFetch: null
  messagesTtl: 60000
  

  subscribe: (callback) =>
    addEventListener(@changeEvent, callback, false)
    @subscribers++
    @emitChange() if @data?
    # @queueMessagesFetch()


  unsubscribe: (callback) =>
    removeEventListener(@changeEvent, callback)
    @subscribers--
    @dequeueMessagesFetch() unless @subscribers > 0


  emitChange: =>
    event = document.createEvent('Event')
    event.initEvent(@changeEvent, true, true)
    dispatchEvent(event)


  set: (data) =>
    @data = data
    @emitChange()


  setToken: (token) ->
    @data.token = token

  
  getAuthHeader: ->
    @user = @get()
    if @user? and @user.token?
      return "Bearer " + @user.token
    else
      return ''

  
  fetchUserData: (navigateTarget) ->
    $.ajax
      type: 'GET'
      headers:
        Authorization: @getAuthHeader()
      url: @urls.get_user_data
      dataType: 'json'
      success: (data) =>
        @setUserAccounts @fixDates(data)
        @doQueueMessages()
        @fetchUserProfile()
        if navigateTarget?
          window.navigate navigateTarget


  fetchUserProfile: (navigateTarget) ->
    $.ajax
      type: 'GET'
      headers:
        Authorization: @getAuthHeader()
      url: @urls.get_current_user
      dataType: 'json'
      success: (data) =>
        @setUserProfile data


  setUserProfile: (data) ->
    @data.profile = data
    @emitChange()


  doQueueMessages: ->
    if @subscribers > 0
      @queueMessagesFetch()
    else
      @dequeueMessagesFetch()

  
  get: =>
    @data


module.exports = new UserStore
  messagestl: 1000 * 60 # 1 minute

