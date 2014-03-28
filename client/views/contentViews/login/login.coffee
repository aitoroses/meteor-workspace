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
		Meteor.call "authenticateUser",[login, password], (err, res) ->
			SessionAmplify.set('workflowContext', res.data)

			# Go to the workspace
			Router.go("workspace")
			NProgress.done()
			
})