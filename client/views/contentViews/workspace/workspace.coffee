#######################
# Template workspace  #
#######################


Template.WorkspaceView.workflowContext = ->
	return JSON.stringify(SessionAmplify.get("workflowContext") || {}, null, 2)


##############################
# Template workspaceTopbar   #
##############################

Template.workspaceTopbar.helpers
	loggedUser: ->
		return SessionAmplify.get('workflowContext').login

##############################
# Template WorkspaceMain     #
##############################

Template.workspaceMain.tasks = ->
  tasks = Collections.Task.find().fetch()
  taskObjects = []
  for task in tasks
    taskObjects.push {
      title: task.task.children[0].val
      assignedDate: new Date task.task.children[5].children[0].val
      taskNumber: parseInt(task.task.children[5].children[9].val)
    }

  return taskObjects

Template.workspaceMain.events
  
    "click .worklist tbody > tr:first-child": (e, tmpl)->
      Meteor.call "getTaskDetailsById", SessionAmplify.get("workflowContext"), "c6daab1e-9a49-46fe-b4fd-27617d8cd2f1", (err, res) -> 

        payload = res.data.children[1]
        vars = payload.children[0]
        obj = {
          requestId: payload.children[1].val
          currentStepId: payload.children[2].val
          businessVars: [
            vars.children[0].val
            vars.children[1].val
            vars.children[2].val
            vars.children[3].val
            vars.children[4].val
          ]
          "notificationReview": payload.children[3].val
        }
        console.log obj

