/*
  Placeholder module for Microsoft Foundry resources.
  Microsoft Foundry APIs and resource types may be preview or tenant-specific.
  This module is a scaffold — implementers should replace with the correct
  resource provider types and any required prerequisite steps (marketplace,
  quotas, billing, and role assignments).

  Example manual tasks (documented in infra/README.md):
  - Create Foundry workspace in westus3
  - Request/enable GPT-4 and Phi model access for the subscription
  - Configure service principal or managed identity access for the app
*/

param foundryWorkspaceName string
param location string = resourceGroup().location

output note string = 'Replace this module with provider-specific Foundry resources. See infra/README.md'
