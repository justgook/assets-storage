React = require 'react'
{ Map, List } = require 'immutable'
Card = require 'views/components/card'
Carousel = require 'views/components/carousel'
Header = require 'views/components/header'

Tree = require 'views/components/tree'
###database sollutions
https://speakerdeck.com/bkeepers/git-the-nosql-database
http://www.iriscouch.com/ + http://pouchdb.com/
https://mongolab.com/
https://www.firebase.com/
https://pusher.com/ - chat
###
module.exports = React.createClass
  getInitialState: ->
    data: Map
      tree: List()
  shouldComponentUpdate: (nextProps, nextState)->
    console.log "Application::shouldComponentUpdate #{nextState.data isnt @state.data}"
    nextState.data isnt @state.data

  render: ->
    data = @state.data
    <div className="wrapper">
      <header className="header">Header</header>
      <article className="main">
        <Tree data = data />
      </article>
      <aside className="aside aside-1">Aside 1</aside>
      <aside className="aside aside-2">Aside 2</aside>
      <footer className="footer">Footer</footer>
    </div>