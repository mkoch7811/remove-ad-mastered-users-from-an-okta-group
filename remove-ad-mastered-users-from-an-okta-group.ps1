[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$api_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$groupid = "xxxxxxxxxxxxxxxxxxxx"
$uri = "https://YOURORG.okta.com/api/v1/groups/$groupid/users?limit=1000"
Do {
    $webrequest = Invoke-WebRequest -Headers @{"Authorization" = "SSWS $api_token"} -Method GET -Uri $uri
    $link = $webrequest.Headers.Link.Split("<").Split(">")
    $uri = $link[3]
    $psobjects = $webrequest | ConvertFrom-Json
    $alum += $psobjects
} while ($webrequest.Headers.Link.EndsWith('rel="next"'))
$alumAD = @($alum | where-object {$_.credentials.provider.type -like "ACTIVE_DIRECTORY"})
if ($alumAD.count -gt 0) {
    foreach ($user in $alumAD) {
        $uri = "https://YOURORG.okta.com/api/v1/groups/$groupid/users/$($user.id)"
        $deleterequest = Invoke-WebRequest -Headers @{"Authorization" = "SSWS $api_token"} -Method DELETE -Uri $uri
    }
}
