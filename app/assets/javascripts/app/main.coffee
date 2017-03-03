window.React = require('react')
window.ReactDOM = require('react-dom')

# RouterMixin = require('react-mini-router').RouterMixin
# window.navigate = require('react-mini-router').navigate
window._ = require('lodash')

# window.UserStore = UserStore = require("./stores/UserStore")

Header = require("./components/Header")
Footer = require("./components/Footer")

{ div } = React.DOM

Blundit = React.createFactory React.createClass
  # mixins: [RouterMixin]

  componentWillMount: ->
    console.log "will mount"


  componentWillUnmount: ->
    console.log "will componentWillUnmount"


  routes:
    '/': 'landing'

  
  landing: ->
    div {},
      Header {}
      Footer {}


  render: ->
    div {},
      # @renderCurrentRoute()
      @landing()


startBlundit = ->
  if document.getElementById('app')?
    ReactDOM.render(
      Blundit { history: true }
      document.getElementById('app')
    )

if window.addEventListener
  window.addEventListener('DOMContentLoaded', startBlundit)
else
  window.attachEvent('onload', startBlundit)
