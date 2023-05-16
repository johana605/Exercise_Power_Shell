# Conexión a Azure
Connect-AzAccount

# Nombre de la suscripción Azure
$subscriptionName = "efa43193-61b3-42cf-a087-6681f44edf7c"

# Selecciona la suscripción activa
Set-AzContext -SubscriptionName $subscriptionName

# Especifica el nombre del grupo de recursos
$resourceGroupName = "rgworkmil"


# grupo de recursos
$resources = Get-AzResource -ResourceGroupName $resourceGroupName

# Imprime las propiedades principales de los recursos en una tabla
$resources | Select-Object Name, ResourceType, Location, Tags | Format-Table -AutoSize

# detalles de configuración
$selectedResource = $resources | Select-Object -First 1

# detalles detallados del primer recurso 
$resourceDetails = Get-AzResource -ResourceId $selectedResource.ResourceId | ConvertTo-Json -Depth 10

# Imprime los detalles detallados del recurso seleccionado
Write-Output "Detalles del recurso:"
Write-Output $resourceDetails | Format-Table -AutoSize

# Añade tags a los recursos
$tags = @{
    Tag_proy1 = "creacion_proy1"
    Tag_proy2 = "creacion_proy2"
}

# Añade los tags a los recursos
$resources | ForEach-Object {
    $resourceId = $_.ResourceId
    Set-AzResource -ResourceId $resourceId -Tag $tags
}

# Verifica si los tags se han establecido correctamente en los recursos
$tagVerification = $resources | ForEach-Object {
    $resourceId = $_.ResourceId
    $tags = (Get-AzResource -ResourceId $resourceId).Tags
    $isSet = $tags.ContainsKey("Tag1") -and $tags.ContainsKey("Tag2")
    [PSCustomObject]@{
        ResourceId = $resourceId
        TagsSet = $isSet
    }
}

# resultados de la verificación de tags
Write-Output "Verificando que los tags estén seteados en los recursos:"
$tagVerification | Format-Table -AutoSize
