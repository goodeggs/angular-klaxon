describe 'angular-klaxon', ->
  beforeEach module 'klaxon'

  beforeEach inject (KlaxonAlert) ->
    # clear alerts between each test run
    KlaxonAlert.all = []

  beforeEach inject ($rootScope, $compile) ->
    @$scope = $rootScope.$new()
    @compileAndRender = (html) =>
      el = $compile(html)(@$scope)
      @$scope.$digest()
      $(document.body).empty().append el
      el

  describe 'KlaxonAlert service', ->
    it 'should create a new alert', inject (KlaxonAlert) ->
      alert = new KlaxonAlert('The floor is lava!', type: 'danger')
      expect(alert.msg).to.equal 'The floor is lava!'
      expect(alert.type).to.equal 'danger'

    it 'should add warnings to KlaxonAlert.all', inject (KlaxonAlert) ->
      one = new KlaxonAlert('one')
      two = new KlaxonAlert('two')
      three = new KlaxonAlert('three')
      one.add()
      two.add()
      three.add()
      expect(KlaxonAlert.all).to.deep.equal [one, two, three]

    it 'should remove warnings from KlaxonAlert.all when close() is called', inject (KlaxonAlert) ->
      one = new KlaxonAlert('one')
      two = new KlaxonAlert('two')
      three = new KlaxonAlert('three')
      one.add()
      two.add()
      three.add()
      one.close()
      two.close()
      three.close()
      expect(KlaxonAlert.all).to.deep.equal []

  describe '<klaxon-alert> directive', ->
    it 'should have a close button by default', inject (KlaxonAlert) ->
      @$scope.alert = new KlaxonAlert('The floor is lava!')
      el = @compileAndRender('<klaxon-alert data="alert"></klaxon-alert>')
      expect(el.find 'button.close').to.be.visible

    it 'should hide the close button on request', inject (KlaxonAlert) ->
      @$scope.alert = new KlaxonAlert('The floor is lava!', closable: false)
      el = @compileAndRender('<klaxon-alert data="alert"></klaxon-alert>')
      expect(el.find 'button.close').not.to.be.visible

  describe '<klaxon-alert-container> directive', ->
    it 'should render the alert container with all the alerts added', inject (KlaxonAlert) ->
      new KlaxonAlert('The floor is lava!').add()
      new KlaxonAlert('Safe!').add()
      el = @compileAndRender '<klaxon-alert-container></klaxon-alert-container>'
      expect(el).to.contain 'The floor is lava!'
      expect(el).to.contain 'Safe!'

    it 'should update the alert container in a timeout when a new alert is added', inject (KlaxonAlert, $timeout) ->
      el = @compileAndRender '<klaxon-alert-container></klaxon-alert-container>'
      new KlaxonAlert('The floor is lava!', key: 'lava').add()
      $timeout.flush()
      expect(el).to.contain 'The floor is lava!'

    it 'should update the alert container when alerts sharing a key are added', inject (KlaxonAlert, $timeout) ->
      new KlaxonAlert('The floor is lava!', key: 'lava').add()
      el = @compileAndRender '<klaxon-alert-container></klaxon-alert-container>'
      new KlaxonAlert('The floor is really, really hot; be careful!', key: 'lava').add()
      $timeout.flush()
      expect(el).not.to.contain 'The floor is lava!'
      expect(el).to.contain 'The floor is really, really hot; be careful!'
