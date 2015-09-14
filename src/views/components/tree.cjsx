React = require 'react'
Immutable = require 'immutable'
{ Map, List } = Immutable

Node = React.createClass

  getDefaultProps: ->
      searchKeyPath: []
      childs: []
      text: "123"
      updated: ->
        console.log "something goes wrong"

  getInitialState: ->
    edit: no
    open: no
    data: Immutable.fromJS
      childs: []
      text: "123"

  doubleClickCheck: null

  componentWillReceiveProps: (nextProps)->
    @setState ({data})-> data: data.mergeDeep @props.data

  componentWillMount: ->
    @setState ({data})-> data: data.mergeDeep @props.data

  clickHandler: (e)->
    if not @state.edit
      if @doubleClickCheck?
        @doubleClickCheck = clearTimeout @doubleClickCheck
        do @startEdit
      else
        @doubleClickCheck = clearTimeout @doubleClickCheck
        @doubleClickCheck = setTimeout (=> @doubleClickCheck = clearTimeout @doubleClickCheck; do @subtree), 200
    e.stopPropagation()
    e.preventDefault()

  startEdit: (e)->
    @props.updated @props.searchKeyPath + ":edit", yes

  stopEdit: (e)->
    @props.updated @props.searchKeyPath + ":edit", no
    if @state.text isnt @props.text #Update only if text is changed
      @props.updated @props.searchKeyPath + ":text", @state.text

  changeText: (e)->
    @setState text: e.target.value

  subtree: ->
    if @props.childs.size
      @props.updated @props.searchKeyPath + ":open", not @state.open
    console.log "Single click"

  componentWillReceiveProps: (nextProps)->
    # console.log " nextProps.text", nextProps.text
    @setState
      text: nextProps.text
      open: nextProps.open? and nextProps.open
      edit: nextProps.edit? and nextProps.edit

  componentDidMount: ->
    @setState
      text: @props.text
      open: @props.open? and @props.open
      edit: @props.edit? and @props.edit

  shouldComponentUpdate: (nextProps, nextState)->
    console.log "Node::shouldComponentUpdate #{nextProps.searchKeyPath.replace /childs:/g, ''}" , nextState.text isnt @state.text or nextState.edit isnt @state.edit or nextState.open isnt @state.open or nextProps.childs isnt @props.childs
    nextState.text isnt @state.text or nextState.edit isnt @state.edit or nextState.open isnt @state.open or nextProps.childs isnt @props.childs

  render: ->
    <li onClick = {@clickHandler} className={if @state.open then "open" else ""}>
      {if @state.edit
        <input type="text" autoFocus onChange = {@changeText} onBlur = {@stopEdit} value = {@state.text} />
      else
        <span className="a">{@state.text}</span>
      }
      {if @props.childs.size
        <ol>
          {for item, index in @props.childs.toArray()
            <Node key="#{index}" updated = {@props.updated} searchKeyPath = {"#{@props.searchKeyPath}:childs:#{index}"} edit = {item.get('edit')} open = {item.get('open')} text = {item.get('text')} childs = {item.get('childs')}  />
          }
        </ol>
      }
    </li>

Tree = React.createClass
  getInitialState: ->
    data: Map
      history: List()
      undoHistory: List()
      tree: List()

  componentWillReceiveProps: (nextProps)->
    @setState ({data})->
      data: data.set 'tree', nextProps.data.get 'tree'
  shouldComponentUpdate: (nextProps, nextState)->
    console.log "update"
    nextState.data isnt @state.data

  update: (searchKeyPath = "", value)->
    search = searchKeyPath.split(":")
    @setState ({data})->
      if search[search.length - 1] is "text"
        data = data.set 'history', data.get('history').push data.get('tree')
        if data.get('undoHistory').size
          data = data.set 'undoHistory', List()
      data: data.set 'tree', data.get('tree').setIn search, value

  add: ->
    @setState ({data})->
      data: data.set 'tree', data.get('tree').unshift Map text: "", edit: true

  undo: ->
    @setState ({data})->
      data = data.set 'undoHistory', data.get('undoHistory').push data.get('tree')
      data = data.set 'tree', data.get('history').last()
      data = data.set 'history', data.get('history').pop()
      data: data

  redo:->
    @setState ({data})->
      data = data.set 'history', data.get('history').push data.get('tree')
      data = data.set 'tree', data.get('undoHistory').last()
      data = data.set 'undoHistory', data.get('undoHistory').pop()
      data: data

  render: ->
    data = @state.data
    <div className = "tree1">
      {if data.get('history').size
        <button onClick={@undo}>Undo</button>
      }
      <button onClick={@add}>Add</button>
      {if data.get('undoHistory').size
        <button onClick={@redo}>Redo</button>
      }
      {if data.get('history').size
        <button>Save</button>
      }
      <button>Load</button>
      <ol>
      {
        for item, index in data.get('tree').toArray()
          <Node key="#{index}" updated = {@update} searchKeyPath = {"#{index}"} edit = {item.get('edit')} open = {item.get('open')} text = {item.get('text')} childs = {item.get('childs')} />
      }
      </ol>
    </div>

module.exports = Tree