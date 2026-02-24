param principalId string
param scope string
param roleDefinitionId string = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

var assignmentName = guid(resourceGroup().id, principalId, scope)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: assignmentName
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
  scope: scope
}

output assignmentId string = roleAssignment.id
