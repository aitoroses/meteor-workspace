###################################################
# App create a namespace and add some utilities.  #
#                                                 #  
# App Namespace                                   #
#                                                 #
###################################################

`App = {}`

Helpers = 
	findNode: (nodeName, xml) ->
		iterateOverChildren = (children)->
			parents = []
			for child in children
				if child.name is nodeName
					return child
				else if child.children.length > 0
					parents.push(child)
			for parent in parents
				return iterateOverChildren(parent.children)
			return undefined
		if xml.name is nodeName then return xml
		else return iterateOverChildren(xml.children)

_.extend(App, Helpers)