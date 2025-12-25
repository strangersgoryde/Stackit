#!/bin/bash
# ==============================================================================
# Barakah Keystore Generation Script (Bash)
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

set -e

echo ""
echo "============================================================"
echo "    BARAKAH KEYSTORE GENERATION SCRIPT"
echo "============================================================"
echo ""
echo "PRIVACY NOTICE:"
echo "  - This script does NOT collect system information"
echo "  - This script does NOT read IP/location/personal data"
echo "  - All values must be entered manually"
echo ""
echo "------------------------------------------------------------"
echo ""

# Verify keytool is available
if ! command -v keytool &> /dev/null; then
    echo "ERROR: keytool not found. Please install Java JDK and ensure it's in your PATH."
    echo "Download JDK from: https://adoptium.net/"
    exit 1
fi

echo "keytool found: $(which keytool)"
echo ""
echo "Please enter the following company details:"
echo "(All fields are required)"
echo ""

# Prompt for company details - ONLY user-provided inputs
read -p "1. Company/Developer Name (e.g., Barakah Studios): " COMPANY_NAME
if [ -z "$COMPANY_NAME" ]; then
    echo "ERROR: Company name cannot be empty."
    exit 1
fi

read -p "2. Organizational Unit (e.g., Mobile Development): " ORG_UNIT
if [ -z "$ORG_UNIT" ]; then
    echo "ERROR: Organizational unit cannot be empty."
    exit 1
fi

read -p "3. Organization (e.g., Barakah Technologies): " ORGANIZATION
if [ -z "$ORGANIZATION" ]; then
    echo "ERROR: Organization cannot be empty."
    exit 1
fi

read -p "4. City/Locality (e.g., Dubai): " CITY
if [ -z "$CITY" ]; then
    echo "ERROR: City cannot be empty."
    exit 1
fi

read -p "5. State/Province (e.g., Dubai): " STATE
if [ -z "$STATE" ]; then
    echo "ERROR: State cannot be empty."
    exit 1
fi

read -p "6. Country Code - 2 letters (e.g., AE): " COUNTRY_CODE
if [ -z "$COUNTRY_CODE" ] || [ ${#COUNTRY_CODE} -ne 2 ]; then
    echo "ERROR: Country code must be exactly 2 letters."
    exit 1
fi
COUNTRY_CODE=$(echo "$COUNTRY_CODE" | tr '[:lower:]' '[:upper:]')

echo ""
echo "------------------------------------------------------------"
echo "Password Setup:"
echo "(Minimum 6 characters required)"
echo ""

# Secure password input
read -s -p "Enter Keystore Password: " STORE_PASSWORD
echo ""
if [ ${#STORE_PASSWORD} -lt 6 ]; then
    echo "ERROR: Password must be at least 6 characters."
    exit 1
fi

read -s -p "Enter Key Password (can be same as store password): " KEY_PASSWORD
echo ""
if [ ${#KEY_PASSWORD} -lt 6 ]; then
    echo "ERROR: Password must be at least 6 characters."
    exit 1
fi

# Generate sanitized alias name
KEY_ALIAS=$(echo "$COMPANY_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | sed 's/[^a-z0-9_]//g')_release_key

# Set keystore filename
KEYSTORE_FILE="barakah-release.jks"

echo ""
echo "------------------------------------------------------------"
echo "Generating Keystore..."
echo ""

# Build the distinguished name
DNAME="CN=$COMPANY_NAME, OU=$ORG_UNIT, O=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY_CODE"

# Generate keystore using keytool
keytool -genkeypair -v \
    -keystore "$KEYSTORE_FILE" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "$DNAME" \
    -storepass "$STORE_PASSWORD" \
    -keypass "$KEY_PASSWORD"

# Verify keystore was created
if [ ! -f "$KEYSTORE_FILE" ]; then
    echo "ERROR: Keystore file was not created."
    exit 1
fi

echo ""
echo "Keystore generated successfully!"
echo ""

# Encode keystore to Base64
echo "Encoding keystore to Base64..."
BASE64_FILE="barakah-keystore-base64.txt"

# Use appropriate base64 command based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    base64 -i "$KEYSTORE_FILE" -o "$BASE64_FILE"
else
    # Linux
    base64 -w 0 "$KEYSTORE_FILE" > "$BASE64_FILE"
fi

echo ""
echo "============================================================"
echo "    KEYSTORE GENERATED SUCCESSFULLY!"
echo "============================================================"
echo ""
echo "GENERATED FILES:"
echo "  - Keystore: $KEYSTORE_FILE"
echo "  - Base64:   $BASE64_FILE"
echo ""
echo "============================================================"
echo "    GITHUB SECRETS SETUP"
echo "============================================================"
echo ""
echo "Add the following secrets to your GitHub repository:"
echo "  Settings -> Secrets and variables -> Actions -> New repository secret"
echo ""
echo "------------------------------------------------------------"
echo ""
echo "Secret Name: BARAKAH_BASE64_KEYSTORE"
echo "Value: (Contents of $BASE64_FILE)"
echo ""
echo "Secret Name: BARAKAH_KEY_ALIAS"
echo "Value: $KEY_ALIAS"
echo ""
echo "Secret Name: BARAKAH_KEY_PASSWORD"
echo "Value: (Your key password)"
echo ""
echo "Secret Name: BARAKAH_STORE_PASSWORD"
echo "Value: (Your store password)"
echo ""
echo "------------------------------------------------------------"
echo ""
echo "IMPORTANT SECURITY NOTES:"
echo "  1. NEVER commit $KEYSTORE_FILE to version control"
echo "  2. NEVER commit $BASE64_FILE to version control"
echo "  3. Store these files securely and delete after adding to GitHub"
echo "  4. The keystore is required to update your app on Play Store"
echo "  5. BACKUP your keystore in a secure location!"
echo ""
echo "============================================================"
echo ""

# Clean up sensitive variables from memory
unset STORE_PASSWORD
unset KEY_PASSWORD

echo "Done!"

