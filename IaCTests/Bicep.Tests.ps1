Describe 'Bicep Template Validation' {
    Context 'Template File Validation' {
        It "Transpiled ARM Template File Exists" {
            Test-Path -Path "..\IaC\main.json" | Should -BeTrue
        }
        It "Transpiled ARM Template is a valid json file" {
            Get-Content "..\IaC\main.json" -raw | ConvertFrom-json -ErrorAction SilentlyContinue | Should -Not -Be $null
        }
    }
    Context 'Template Content Validation' {
        $Resources = @(
            'Microsoft.Sql/servers',
            'Microsoft.Sql/servers/databases',
            'icrosoft.Sql/servers/firewallRules',
            'Microsoft.ContainerRegistry/registries',
            'Microsoft.Web/serverfarms',
            'Microsoft.Web/sites',
            'Microsoft.Web/sites/config',
            'Microsoft.Web/sites/slots',
            'Microsoft.Insights/components'
        )
        It "Only has approved resources" {
            $resourcesFromTemplate = $TemplateJson.resources.type | Sort-Object
            $strResourcesFromTemplate = $resourcesFromTemplate -join ','
            $resources = $resources | Sort-Object
            $strResources = $resources -join ','
            $strResourcesFromTemplate | Should -be $strResources
        }
    }
}