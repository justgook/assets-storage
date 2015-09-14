zombie = require 'zombie'
module.exports = ->
    @World = (next)->
      @browser = new zombie() # this.browser will be available in step definitions
      @browser.silent = false

      @visit = (url, next)->
        @browser.visit url, next
      next() #tell Cucumber we're finished and to use 'this' as the world instance