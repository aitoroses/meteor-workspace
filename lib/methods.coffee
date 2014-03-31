
# Meteor server methods

if Meteor.isServer

  Meteor.methods

    authenticateUser: (login, password) ->
      console.log "\n----------------- Call on authenticateUser ----------------"
      console.log 'Calling authenticate user with: ' + [login, password]
      url = "http://localhost:3100/authenticate?login=#{login}&#{password}"
      console.log url
      console.log "------------------------ Call end -------------------------\n"
      return HTTP.get url


    getTasks: (workflowContext) ->
      console.log "\n-------------------- Call on getTasks ---------------------"
      console.log "Calling getTasks for user #{workflowContext.login}."
      console.log "------------------------ Call end -------------------------\n"
      return HTTP.get "http://localhost:3100/humantask"


    getTaskDetailsById: (workflowContext, taskId) ->
      console.log "\n-------------------- Call on getTasksDetailsById ---------------------"
      console.log "Calling getTasks for user #{workflowContext.login}."
      console.log "TaskId:  #{taskId}"
      console.log "------------------------------ Call end ------------------------------\n"
      return HTTP.get "http://localhost:3100/humantask/#{taskId}"


  