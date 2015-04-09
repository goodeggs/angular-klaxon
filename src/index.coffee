module.exports = angular.module 'klaxon', []

.factory 'KlaxonAlert', ['$rootScope', '$interval', ($rootScope, $interval) ->
  class KlaxonAlert
    @all: []

    ###
    @param {String} msg - alert message to display
    @param {String} type - type of bootstrap alert (what color)
    @param {String} [key] - key for identifying alert for avoiding duplicates
    @param {Number} [priority] - higher priority takes precedent when two alerts have the same key
    @param {Boolean} [closable] - alert closable by x icon
    @param {String} [callToAction] - clickable message displayed in alert
    @param {Function} [onClick] - callback when alert is clicked
    @param {Function} [onCallToActionClick] - callback when call to action is clicked
    @param {Number} [timeout] - timeout for removing the this alert
    @param {String} [debugInfo] - extra info to display inside alert for engineer
    ###
    constructor: (@msg, {@type, @key, @priority, @closable, @callToAction, @onClick, @onCallToActionClick, @debugInfo, @timeout} = {}) ->
      @type ?= 'info'
      @closable ?= yes

    click: ($event) ->
      $event?.preventDefault()
      @onClick?($event)

    clickCallToAction: ($event) ->
      $event?.preventDefault()
      @onCallToActionClick?($event)

    ###
    Add alert to list of displayed alerts
    ###
    add: ->
      return if @getIndex()? # alert has already been added, don't add it twice

      # find/remove alerts with the same key
      appendAlert = true

      if @key and KlaxonAlert.all.some((alert) => alert.key is @key)
        KlaxonAlert.all.forEach (alert) =>
          return unless alert.key is @key
          if alert.priority > @priority
            appendAlert = false
          else
            alert.close()

      return unless appendAlert

      KlaxonAlert.all.push @

      $interval @close.bind(@), @timeout, 1 if @timeout?

      # tell anything that renders alerts to $digest and update itself
      $rootScope.$broadcast 'klaxon.alertAdded', @

    close: ($event) ->
      $event?.preventDefault?()
      index = @getIndex()
      return unless index?
      KlaxonAlert.all.splice index, 1

    getIndex: ->
      for alert, index in KlaxonAlert.all
        return index if alert is @
]

.directive 'klaxonAlert', ->
  restrict: 'E'
  scope:
    alert: '=data'
  template: """
    <div
      class='alert'
      ng-class="['alert-' + (alert.type || 'warning'), alert.closable ? 'alert-dismissable' : null]"
      ng-click="alert.click($event)"
      role="alert"
    >
      <button
        ng-show="alert.closable"
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
        ng-click='alert.clickCallToAction($event)'
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

.directive 'klaxonAlertContainer', ['KlaxonAlert', '$timeout', (KlaxonAlert, $timeout) ->
  restrict: 'E'
  template: """
    <div class='alerts' ng-if='alerts.length > 0'>
      <klaxon-alert data='alert' ng-repeat='alert in alerts'></alert>
    </div>
  """
  link: (scope, element, attrs) ->
    scope.alerts = KlaxonAlert.all

    scope.$on 'klaxon.alertAdded', ->
      scope.alerts = KlaxonAlert.all
      $timeout (-> scope.$digest() unless scope.$$phase), 1
]
