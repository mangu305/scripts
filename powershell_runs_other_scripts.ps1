# Script paths
$scripts = @(
    "path\to\script",
    "path\to\script",
    "path\to\script",
    "path\to\script",
    "path\to\script"
)

# Execute each script and wait to finish successfully
foreach ($script in $scripts) {
    Write-Host "Running $script..."
    & $script
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Script $script failed with exit code $LASTEXITCODE. Stopping execution."
        exit $LASTEXITCODE
    }
    Write-Host "$script completed successfully."
}

Write-Host "All scripts executed successfully."
