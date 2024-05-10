Add-Content -Path "C:/Users/Damilola/.ssh/config" -Value @"
Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityfile}
"@
