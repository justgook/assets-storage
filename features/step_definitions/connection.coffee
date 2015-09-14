module.exports = ->
  @When /^I open application$/, (callback) ->
    # Write code here that turns the phrase above into concrete actions
    callback.pending()

  @Then /^application should create connection to websocket$/, (callback) ->
    # Write code here that turns the phrase above into concrete actions
    callback.pending()