describe 'angular-klaxon', ->
  beforeEach module 'klaxon'

  beforeEach inject (Alert) ->
    # clear alerts between each test run
    Alert.all = []

  describe 'Alert service', ->
    it 'should create a new alert', inject (Alert) ->
      alert = new Alert('The floor is lava!', type: 'danger')
      expect(alert.msg).to.equal 'The floor is lava!'
      expect(alert.type).to.equal 'danger'

  describe '<alert-container> directive', ->
    beforeEach inject ($compile, $rootScope) ->
      @$scope = $rootScope.$new()
      @renderAlertContainer = $compile '<alert-container></alert-container>'

    it 'should render the alert container with all the alerts added', inject (Alert) ->
      alert = new Alert('The floor is lava!')
      alert.add()
      @el = @renderAlertContainer(@$scope)
      @$scope.$digest()
      expect(@el).to.contain 'The floor is lava!'
