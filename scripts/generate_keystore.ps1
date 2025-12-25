# ==============================================================================
# Barakah Keystore Generation Script (PowerShell)
# ==============================================================================
# This script generates a JKS keystore for signing Android applications.
#
# PRIVACY NOTICE:
# - This script does NOT collect any system information
# - This script does NOT read IP address, location, or personal data
# - This script does NOT auto-fill any values
# - All information is provided manually by the user
#
# REQUIREMENTS:
# - Java JDK installed with keytool available in PATH
# ==============================================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "    BARAKAH KEYSTORE GENERATION SCRIPT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PRIVACY NOTICE:" -ForegroundColor Yellow
Write-Host "  - This script does NOT collect system information" -ForegroundColor Yellow
Write-Host "  - This script does NOT read IP/location/personal data" -ForegroundColor Yellow
Write-Host "  - All values must be entered manually" -ForegroundColor Yellow
Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host ""

# Verify keytool is available
try {
    $keytoolPath = Get-Command keytool -ErrorAction Stop
    Write-Host "keytool found at: $($keytoolPath.Source)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: keytool not found. Please install Java JDK and ensure it's in your PATH." -ForegroundColor Red
    Write-Host "Download JDK from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Please enter the following company details:" -ForegroundColor Cyan
Write-Host "(All fields are required)" -ForegroundColor Gray
Write-Host ""

# Prompt for company details - ONLY user-provided inputs
$companyName = Read-Host "1. Company/Developer Name (e.g., Barakah Studios)"
if ([string]::IsNullOrWhiteSpace($companyName)) {
    Write-Host "ERROR: Company name cannot be empty." -ForegroundColor Red
    exit 1
}

$organizationalUnit = Read-Host "2. Organizational Unit (e.g., Mobile Development)"
if ([string]::IsNullOrWhiteSpace($organizationalUnit)) {
    Write-Host "ERROR: Organizational unit cannot be empty." -ForegroundColor Red
    exit 1
}

$organization = Read-Host "3. Organization (e.g., Barakah Technologies)"
if ([string]::IsNullOrWhiteSpace($organization)) {
    Write-Host "ERROR: Organization cannot be empty." -ForegroundColor Red
    exit 1
}

$city = Read-Host "4. City/Locality (e.g., Dubai)"
if ([string]::IsNullOrWhiteSpace($city)) {
    Write-Host "ERROR: City cannot be empty." -ForegroundColor Red
    exit 1
}

$state = Read-Host "5. State/Province (e.g., Dubai)"
if ([string]::IsNullOrWhiteSpace($state)) {
    Write-Host "ERROR: State cannot be empty." -ForegroundColor Red
    exit 1
}

$countryCode = Read-Host "6. Country Code - 2 letters (e.g., AE)"
if ([string]::IsNullOrWhiteSpace($countryCode) -or $countryCode.Length -ne 2) {
    Write-Host "ERROR: Country code must be exactly 2 letters." -ForegroundColor Red
    exit 1
}
$countryCode = $countryCode.ToUpper()

Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host "Password Setup:" -ForegroundColor Cyan
Write-Host "(Minimum 6 characters required)" -ForegroundColor Gray
Write-Host ""

# Secure password input
$storePassword = Read-Host "Enter Keystore Password" -AsSecureString
$storePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($storePassword))
if ($storePasswordPlain.Length -lt 6) {
    Write-Host "ERROR: Password must be at least 6 characters." -ForegroundColor Red
    exit 1
}

$keyPassword = Read-Host "Enter Key Password (can be same as store password)" -AsSecureString
$keyPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPassword))
if ($keyPasswordPlain.Length -lt 6) {
    Write-Host "ERROR: Password must be at least 6 characters." -ForegroundColor Red
    exit 1
}

# Generate sanitized alias name
$keyAlias = ($companyName -replace '\s+', '_' -replace '[^a-zA-Z0-9_]', '').ToLower() + "_release_key"

# Set keystore filename with full path (in scripts folder)
$scriptDir = $PSScriptRoot
$keystoreFile = Join-Path $scriptDir "barakah-release.jks"

Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host "Generating Keystore..." -ForegroundColor Cyan
Write-Host ""

# Build the distinguished name (escape quotes for command line)
$dname = "CN=$companyName, OU=$organizationalUnit, O=$organization, L=$city, ST=$state, C=$countryCode"

# Generate keystore using keytool with proper argument handling
# Using & operator with explicit quoting for dname to handle spaces
# Using -storetype JKS explicitly (newer Java defaults to PKCS12 which doesn't support different passwords)
try {
    & keytool -genkeypair -v `
        -storetype JKS `
        -keystore $keystoreFile `
        -alias $keyAlias `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000 `
        -dname "`"$dname`"" `
        -storepass $storePasswordPlain `
        -keypass $keyPasswordPlain
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to generate keystore. Exit code: $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Failed to run keytool: $_" -ForegroundColor Red
    exit 1
}

# Verify keystore was created
if (-not (Test-Path $keystoreFile)) {
    Write-Host "ERROR: Keystore file was not created at: $keystoreFile" -ForegroundColor Red
    Write-Host "Please check if you have write permissions to this directory." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Keystore generated successfully at: $keystoreFile" -ForegroundColor Green
Write-Host ""

# Encode keystore to Base64
Write-Host "Encoding keystore to Base64..." -ForegroundColor Cyan
try {
    $keystoreBytes = [System.IO.File]::ReadAllBytes($keystoreFile)
    $base64Keystore = [System.Convert]::ToBase64String($keystoreBytes)
    Write-Host "Base64 encoding complete. Length: $($base64Keystore.Length) characters" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to read keystore file: $_" -ForegroundColor Red
    exit 1
}

# Create output file for base64 (so user can copy it easily)
$base64File = Join-Path $scriptDir "barakah-keystore-base64.txt"
$base64Keystore | Out-File -FilePath $base64File -Encoding ASCII

Write-Host ""
# Get just the filenames for display
$keystoreFileName = Split-Path $keystoreFile -Leaf
$base64FileName = Split-Path $base64File -Leaf

Write-Host "============================================================" -ForegroundColor Green
Write-Host "    KEYSTORE GENERATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "GENERATED FILES (in scripts folder):" -ForegroundColor Cyan
Write-Host "  - Keystore: $keystoreFileName" -ForegroundColor White
Write-Host "  - Base64:   $base64FileName" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Yellow
Write-Host "    GITHUB SECRETS SETUP" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add the following secrets to your GitHub repository:" -ForegroundColor Cyan
Write-Host "  Settings -> Secrets and variables -> Actions -> New repository secret" -ForegroundColor Gray
Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host ""
Write-Host "Secret Name: BARAKAH_BASE64_KEYSTORE" -ForegroundColor Yellow
Write-Host "Value: (Contents of $base64FileName)" -ForegroundColor Gray
Write-Host ""
Write-Host "Secret Name: BARAKAH_KEY_ALIAS" -ForegroundColor Yellow
Write-Host "Value: $keyAlias" -ForegroundColor White
Write-Host ""
Write-Host "Secret Name: BARAKAH_KEY_PASSWORD" -ForegroundColor Yellow
Write-Host "Value: (Your key password)" -ForegroundColor Gray
Write-Host ""
Write-Host "Secret Name: BARAKAH_STORE_PASSWORD" -ForegroundColor Yellow
Write-Host "Value: (Your store password)" -ForegroundColor Gray
Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host ""
Write-Host "IMPORTANT SECURITY NOTES:" -ForegroundColor Red
Write-Host "  1. NEVER commit $keystoreFileName to version control" -ForegroundColor Red
Write-Host "  2. NEVER commit $base64FileName to version control" -ForegroundColor Red
Write-Host "  3. Store these files securely and delete after adding to GitHub" -ForegroundColor Red
Write-Host "  4. The keystore is required to update your app on Play Store" -ForegroundColor Red
Write-Host "  5. BACKUP your keystore in a secure location!" -ForegroundColor Red
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Clean up sensitive variables from memory
$storePasswordPlain = $null
$keyPasswordPlain = $null
[System.GC]::Collect()

Write-Host "Done! Press any key to exit..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

