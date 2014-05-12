#######################
# Template workspace  #
#######################


Session.set("formData", null)
Session.set("selectedRowContext", null)


Template.WorkspaceView.workflowContext = ->
	return JSON.stringify(SessionAmplify.get("workflowContext") || {}, null, 2)

Template.WorkspaceView.events
  
  "click .logout": ->
    SessionAmplify.set("workflowContext", null)
    Session.set("formData", null)
    Session.set("selectedRowContext", null)
    Router.go("login")


##############################
# Template workspaceTopbar   #
##############################

Template.workspaceTopbar.helpers
  loggedUser: ->
    context = SessionAmplify.get('workflowContext') || {}
    return context.login

##############################
# Template WorkspaceMain     #
##############################

Template.workspaceMain.taskCount = ->
  return Collections.Task.find().count()

Template.workspaceMain.tasks = ->
  filter = Session.get("searchFilter") || ""
  tasks = Collections.Task.find().fetch()
  taskObjects = []
  for task in tasks
    xml = task.task
    findNode = App.findNode
    
    if findNode("title", xml).val.match(filter)
      taskObjects.push {
        _id: task._id
        title: findNode("title", xml).val
        assignedDate: findNode("assignedDate", xml).val
        taskNumber: parseInt(findNode("taskNumber", xml).val)
        taskDefinitionId: findNode("taskDefinitionId", xml).val
        taskId: findNode("taskId", xml).val
        creator: findNode("creator", xml).val
      }
  return taskObjects

Template.workspaceMain.events
    "submit .worklistToolbar form": (e) ->
      e.preventDefault()

    "change .worklistToolbar input": (e, tmpl) ->
      Session.set("searchFilter", $(e.target).val())
  
    "click .worklist tbody > tr": (e, tmpl)->

      # Save the context because it will get loose (Maybe we'll not need this)
      Session.set('selectedRowContext', this)

      # Session formData gets cleaned, so UI gets cleaned
      Session.set("formData", null) 

      Meteor.call "getTaskDetailsById", SessionAmplify.get("workflowContext"), this.taskId, (err, res) ->
        
        find = App.findNode
        xml = res.data
        payload = find("payload", xml)
        vars = find("VariablesBusinessObject", payload) || {children: "12345"}
        obj = {
          requestId: find("requestId", payload).val
          currentStepId: find("currentStepId", payload).val
          businessVars: [
            vars.children[0].val
            vars.children[1].val
            vars.children[2].val
            vars.children[3].val
            vars.children[4].val
          ]
        }
        
        # Print the object
        console.log obj

        # Get the form
        Meteor.call "getForm", obj.requestId, (err, res) ->
          if not err
            console.log(res.data)
            Session.set("formData", res.data)
          else console.error("There was an error calling getForm.")


