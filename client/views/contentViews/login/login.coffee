######################
# Template Login     #
######################

Template.LoginView.events({

	'click #login-btn': (e, tmpl) ->
		# Prevent default button submit behaviour
		e.preventDefault()
		console.log("login clicked")
		
		login = tmpl.find("input[name='login']").value
		password = tmpl.find("input[name='password']").value

		NProgress.start()

		# Call meteor authenticate method
		Meteor.call "authenticateUser", login, password, (err, res) ->
			workflowContext = if res.data? then res.data.workflowContext
			if workflowContext? 
				SessionAmplify.set('workflowContext', workflowContext)
			else throw Error("Login error")
			
			# Retrieve the requests
			Meteor.call 'getTasks', workflowContext, (err, res) ->
				taskListResponse = res.data.taskListResponse

				if typeof taskListResponse is "object"

					Task = Collections.Task

					# Clean old
					existingTasks = Task.find().fetch()
					for task in existingTasks
						Task.remove({_id: task._id})

					# Fetch new
					for taskNode in taskListResponse
						processedTaskNode = ->
							task = {}
							for part in taskNode.task
								_.extend(task, part)
							return task

						taskObject = {
							userId: workflowContext.credential.login
							task: processedTaskNode()
						}

						Task.insert(taskObject)

				else throw Error("No task was found")

			# Go to the workspace
			Router.go("workspace")
			NProgress.done()
			
})

# Placeholder polyfill
Template.LoginView.rendered = ->
	$("input").placeholder()

	