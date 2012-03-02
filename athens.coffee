require('zappa') ->
  @enable 'default layout'
  @use 'bodyParser'
 
  @get '/': ->
    @render index: {stylesheets: ['app']}

  @view result: ->
    h1 'The following warnings were produced'
    p @warnings
    
  @view index: ->
    
    h1 'Athens Registration'
    
    form method: 'post', action: '/', ->
      
      formElement = (id, type, placeholder) ->
        label for: id, -> placeholder
        input type: type, id: id, required: 'required', name: id, placeholder: placeholder
      
      formElement 'institution', 'text', 'Institution'
      label for: 'title', -> 'Title'
      select id: 'title', name: 'title', ->
        for title in ['Dr', 'Miss', 'Mr', 'Mrs', 'Ms', 'Professor']
          option value: title, -> title 
      formElement 'forenames', 'text', 'Forenames'
      formElement 'surname', 'text', 'Surname'
      formElement 'email', 'email', 'Email'
      formElement 'email2', 'email', 'Confirm Email'

      button 'Submit'

  @post '/': ->
    assert = require "assert"
    Browser = require "zombie"
    browser = new Browser()
    body = @request.body
    browser.visit "https://register.athensams.net/nhs/nhseng/", =>
      assert.ok browser.success
      console.dir browser.errors if browser.error
      browser.
      fill("institution", body.institution).
      select("title", body.title).
      fill("forenames", body.forenames).
      fill("email", body.email).
      fill("email2", body.email2).
      pressButton "Submit", => 
        @render result: { warnings: browser.html("p.warn"), stylesheets: ['app']}
              
  @stylus '/app.css': '''
    border-radius()
      -webkit-border-radius arguments  
      -moz-border-radius arguments  
      border-radius arguments  

    body
      font 12px Helvetica, Arial, sans-serif  
    
    input
      display block
      width 100% 
      margin 0.5em 0
    
    select
      display block
    
    button, input
      border-radius 3px
  '''