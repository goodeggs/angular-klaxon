describe 'angular-klaxon', ->
  beforeEach module 'klaxon'

  beforeEach inject (Alert) ->
    # clear alerts between each test run
    Alert.all = []

  beforeEach inject ($rootScope, $compile) ->
    @$scope = $rootScope.$new()
    @compileAndRender = (html) =>
      el = $compile(html)(@$scope)
      @$scope.$digest()
      $(document.body).empty().append el
      el

  describe 'Alert service', ->
    it 'should create a new alert', inject (Alert) ->
      alert = new Alert('The floor is lava!', type: 'danger')
      expect(alert.msg).to.equal 'The floor is lava!'
      expect(alert.type).to.equal 'danger'

  describe '<klaxon-alert> directive', ->
    it 'should have a close button by default', inject (Alert) ->
      @$scope.alert = new Alert('The floor is lava!')
      el = @compileAndRender('<klaxon-alert data="alert"></klaxon-alert>')
      console.log el.html()
      expect(el.find 'button.close').to.be.visible

    it 'should hide the close button on request', inject (Alert) ->
      @$scope.alert = new Alert('The floor is lava!', closable: false)
      el = @compileAndRender('<klaxon-alert data="alert"></klaxon-alert>')
      expect(el.find 'button.close').not.to.be.visible

  describe '<alert-container> directive', ->
    it 'should render the alert container with all the alerts added', inject (Alert) ->
      alert = new Alert('The floor is lava!')
      alert.add()
      el = @compileAndRender '<alert-container></alert-container>'
      expect(el).to.contain 'The floor is lava!'
