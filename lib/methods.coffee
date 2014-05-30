
# Meteor server methods

if Meteor.isServer

  # Server
  server = "http://localhost:9000"

  Meteor.methods

    authenticateUser: (login, password) ->
      console.log "\n----------------- Call on authenticateUser ----------------"
      console.log 'Calling authenticate user with: ' + [login, password]
      url = "#{server}/TaskQueryService/AuthenticateOperation?login=#{login}&password=#{password}"
      console.log url
      console.log "------------------------ Call end -------------------------\n"
      return HTTP.get url


    getTasks: (workflowContext) ->
      console.log "\n-------------------- Call on getTasks ---------------------"
      console.log "Calling getTasks for user #{workflowContext.credential.login}."
      console.log "Token:  #{workflowContext.token}"
      console.log "------------------------ Call end -------------------------\n"
      return HTTP.post "#{server}/TaskQueryService/GetTasksOperation", {data: {token: workflowContext.token}}


    getTaskDetailsById: (workflowContext, taskId) ->
      console.log "\n-------------------- Call on getTasksDetailsById ---------------------"
      console.log "Calling getTasks for user #{workflowContext.credential.login}."
      console.log "TaskId:  #{taskId}"
      console.log "Token:  #{workflowContext.token}"
      console.log "------------------------------ Call end ------------------------------\n"
      return HTTP.get "#{server}/TaskQueryService/GetTaskDetailsByIdOperation", {data: {token: workflowContext.token}}

    getForm: (requestId) ->
      console.log "\n-------------------------- Call on getForm ---------------------------"
      console.log "Calling getForm."
      console.log "requestId:  #{requestId}"
      console.log "------------------------------ Call end ------------------------------\n"
      return HTTP.get "http://localhost:3100/form/#{requestId}"


  