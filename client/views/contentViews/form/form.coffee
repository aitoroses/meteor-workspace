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