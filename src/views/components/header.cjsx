React = require 'react'
module.exports = React.createClass
  render: ->
    <header className="header">
      <nav>
        <a href="/html/">HTML</a> |
        <a href="/css/">CSS</a> |
        <a href="/js/">JavaScript</a> |
        <a href="/jquery/">jQuery</a>
      </nav>
    </header>