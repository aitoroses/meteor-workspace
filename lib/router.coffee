if Meteor.isClient


    ########################################
    # Controllers                          #
    ########################################

    # Configure Router to use the Main template
    Router.configure
        layoutTemplate: "App"
        notFoundTemplate: "notFoundTemplate"


    # Login Controller
    LoginController = FastRender.RouteController.extend
        template: "LoginView"


    # Login Controller
    WorkspaceController = FastRender.RouteController.extend
        template: "WorkspaceView"
        onBeforeAction: ->
            context = SessionAmplify.get("workflowContext")
            if not context?
                Router.go("login")


    ########################################
    # Routes                               #
    ########################################

    Router.map ->

        @route "login",
            path : "/login"
            controller: LoginController

        @route "workspace",
            path : "/workspace"
            controller: WorkspaceController

