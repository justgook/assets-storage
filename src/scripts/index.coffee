React = require 'react'
Immutable = require 'immutable'
{ Map, List } = Immutable
Application = require 'views/application'
app = React.render React.createElement(Application), document.body


tree = [
  text:"top element 1"
  childs: [
    text:"element 1.1"
  ,
    text:"element 1.2"
  ,
    text:"element 1.3"
    childs: [
      text:"element 1.3.1"
    ,
      text:"element 1.3.2"
    ,
      text:"element 1.3.3"
    ]
  ]
,
  text:"top element 2"
,
  text:"top element 3"
]

tree1 = Immutable.fromJS tree
# tree2 = Immutable.fromJS tree

# console.log tree1.get(0) is tree1.toArray()[0]
app.setState ({data})-> data: data.set 'tree', tree1


# newState = app.state.data.get('tree').mergeDeep tree2

# console.log newState is app.state.data.get('tree')

# setTimeout (-> app.setState ({data})-> data:  data.set 'tree', data.get('tree').mergeDeep tree2), 1000


# localStorage.setItem "username", "John"
# localStorage.getItem "username"