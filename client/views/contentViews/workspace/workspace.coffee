#######################
# Template workspace  #
#######################


Session.set("formData", null)
Session.set("selectedRowContext", null)


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

Template.workspaceMain.taskCount = ->
  return Collections.Task.find().count()

Template.workspaceMain.tasks = ->
  filter = Session.get("searchFilter") || ""
  tasks = Collections.Task.find().fetch()
  taskObjects = []
  for task in tasks
    if task.task.children[0].val.match(filter)
      taskObjects.push {
        _id: task._id
        title: task.task.children[0].val
        assignedDate: new Date task.task.children[5].children[0].val
        taskNumber: parseInt(task.task.children[5].children[9].val)
      }
  return taskObjects

Template.workspaceMain.events
    "submit .worklistToolbar form": (e) ->
      e.preventDefault()

    "change .worklistToolbar input": (e, tmpl) ->
      Session.set("searchFilter", $(e.target).val())
  
    "click .worklist tbody > tr:first-child": (e, tmpl)->

      # Save the context because it will get loose (Maybe we'll not need this)
      Session.set('selectedRowContext', this)

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

        # Print the object
        console.log obj

        # Get the form
        Meteor.call "getForm", 8302, (err, res) ->
          if not err
            console.log(res.data)
            Session.set("formData", res.data)
          else console.error("There was an error calling getForm.")

Template.formView.categories = ->
  data = Session.get("formData") || {}

  getCategories = (data) ->
    if data.children?
      cats = (child for child in data.children when child.name is "ns1:categories")
    else cats = []
  
  data = getCategories(data)

  return data

Template.formView.title = ->
  selectedRow = Session.get("selectedRowContext") || {}
  return selectedRow.title


Template.category.fields = ->
  fields = []
  for field in this.children
    activityConfig = field.children[1]
    runtimeConfig = field.children[3]
    validValues = field.children[4] || {}
    
    field = {
      fieldType: field.children[0].val
      label: activityConfig.children[0].val
      visible: activityConfig.children[2].val
      mandatory: activityConfig.children[3].val
      value: runtimeConfig.children[0].val
      validValues: validValues
    }
    fields.push(field)

  return fields

Template.category.name = -> this.attr.name

Template.field.validValues = ->
  validValues = []
  if this.validValues?
    for valid in this.validValues.children
      validValues.push {
        id: valid.attr.id
        value: valid.attr.value
      }

  return validValues

