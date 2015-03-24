module.exports = angular.module 'klaxon', []

.factory 'Alert', ['$rootScope', '$timeout', ($rootScope, $timeout) ->
  class Alert
    @all: []

    ###
    @param {String} msg - alert message to display
    @param {String} type - type of bootstrap alert (what color)
    @param {String} [key] - key for identifying alert for avoiding duplicates
    @param {Number} [priority] - higher priority takes precedent when two alerts have the same key
    @param {Boolean} [closable] - alert closable by x icon
    @param {String} [callToAction] - clickable message displayed in alert
    @param {Function} [onClick] - callback when call to action is clicked
    @param {Number} [timeout] - timeout for removing the this alert
    @param {String} [debugInfo] - extra info to display inside alert for engineer
    ###
    constructor: (@msg, {@type, @key, @priority, @closable, @callToAction, @onClick, @debugInfo, @timeout} = {}) ->
      @type ?= 'info'
      @closable ?= yes

    click: ($event) ->
      $event?.preventDefault()
      @onClick?($event)

    ###
    Add alert to list of displayed alerts
    ###
    add: ->
      return if @index?
      @index = Alert.all.length

      if @key and Alert.all.some((alert) => alert.key is @key)
        Alert.all = Alert.all.map (alert) =>
          if alert.key isnt @key or alert.priority > @priority
            alert
          else
            @
      else
        Alert.all.push @

      $timeout @close.bind(@), @timeout if @timeout?

      # required for the layout to re-render and make alerts appear.
      $timeout ->
        $rootScope.$digest() unless $rootScope.$$phase
      , 1

    close:($event) ->
      $event?.preventDefault?()
      Alert.all.splice @index, 1
]

.directive 'klaxonAlert', ->
  restrict: 'E'
  scope:
    alert: '=data'
  template: """
    <div
      class='alert'
      ng-class="['alert-' + (alert.type || 'warning'), alert.closeable ? 'alert-dismissable' : null]"
      role="alert"
    >
      <button
        ng-show="closeable"
        type="button"
        class="close"
        ng-click="alert.close($event)"
      >
        <span aria-hidden="true">&times;</span>
        <span class="sr-only">Close</span>
      </button>

      {{ alert.msg }}&nbsp;

      <a
        class='alert-link'
        ng-if='alert.callToAction'
        ng-click='alert.click($event)'
        href='#'
      >
        {{alert.callToAction}}
      </a>

      <div
        class='debug-info'
        ng-if='alert.debugInfo'
      >
        {{ alert.debugInfo }}
      </div>
    </div>
  """

.directive 'alertContainer', ['Alert', (Alert) ->
  restrict: 'E'
  template: """
    <div class='alerts' ng-if='alerts.length > 0'>
      <klaxon-alert data='alert' ng-repeat='alert in alerts'></alert>
    </div>
  """
  link: (scope, element, attrs) ->
    scope.alerts = Alert.all
]
