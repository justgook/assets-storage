Feature: Connection
  Scenario: Application must automatically connect to server
    When I open application
    Then application should create connection to websocket
