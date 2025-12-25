# Android App Signing & CI/CD Guide

This document explains how to set up secure Android app signing with GitHub Actions for **Stack The Snack (Barakah)**.

---

## Table of Contents

- [Overview](#overview)
- [Privacy & Security Statement](#privacy--security-statement)
- [Prerequisites](#prerequisites)
- [Step 1: Generate Keystore](#step-1-generate-keystore)
- [Step 2: Configure GitHub Secrets](#step-2-configure-github-secrets)
- [Step 3: Trigger the Build](#step-3-trigger-the-build)
- [Step 4: Download Artifacts](#step-4-download-artifacts)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

This project uses GitHub Actions to automatically build signed APK and AAB files on every push. The workflow:

- ✅ Builds signed **APK** (for direct installation)
- ✅ Builds signed **AAB** (for Google Play Store)
- ✅ Uses keystore from GitHub Secrets only
- ✅ Decodes keystore from Base64 at runtime
- ✅ Deletes sensitive files after build
- ✅ Never exposes secrets in logs
- ✅ Uploads artifacts for download

---

## Privacy & Security Statement

### The keystore generation script (`scripts/generate_keystore.ps1` or `scripts/generate_keystore.sh`):

- ❌ Does **NOT** collect any system information
- ❌ Does **NOT** read your IP address
- ❌ Does **NOT** access your location
- ❌ Does **NOT** auto-fill any values
- ❌ Does **NOT** send data anywhere
- ✅ Only uses the values **you manually provide**

All company details are entered by you, ensuring complete privacy.

---

## Prerequisites

Before starting, ensure you have:

1. **Java JDK** installed (JDK 11 or higher)
   - Download from: https://adoptium.net/
   - Verify: `keytool -help`

2. **Git** installed and repository cloned

3. **GitHub repository** with Actions enabled

---

## Step 1: Generate Keystore

### Windows (PowerShell)

```powershell
cd scripts
.\generate_keystore.ps1
```

### macOS/Linux (Bash)

```bash
cd scripts
chmod +x generate_keystore.sh
./generate_keystore.sh
```

### What You'll Be Asked

The script will prompt you for:

| # | Field | Example |
|---|-------|---------|
| 1 | Company/Developer Name | Barakah Studios |
| 2 | Organizational Unit | Mobile Development |
| 3 | Organization | Barakah Technologies |
| 4 | City/Locality | Dubai |
| 5 | State/Province | Dubai |
| 6 | Country Code (2 letters) | AE |
| 7 | Keystore Password | (your secure password) |
| 8 | Key Password | (your secure password) |

### Generated Files

After running the script, you'll have:

- `barakah-release.jks` - The actual keystore file
- `barakah-keystore-base64.txt` - Base64-encoded keystore for GitHub Secrets

---

## Step 2: Configure GitHub Secrets

Navigate to your GitHub repository:

**Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these 4 secrets:

| Secret Name | Value |
|-------------|-------|
| `BARAKAH_BASE64_KEYSTORE` | Contents of `barakah-keystore-base64.txt` |
| `BARAKAH_KEY_ALIAS` | The alias shown after script runs (e.g., `barakah_studios_release_key`) |
| `BARAKAH_KEY_PASSWORD` | Your key password |
| `BARAKAH_STORE_PASSWORD` | Your keystore password |

### How to Copy Base64 Keystore

```bash
# Windows PowerShell
Get-Content barakah-keystore-base64.txt | Set-Clipboard

# macOS
cat barakah-keystore-base64.txt | pbcopy

# Linux (with xclip)
cat barakah-keystore-base64.txt | xclip -selection clipboard
```

---

## Step 3: Trigger the Build

The workflow runs automatically on:

- Push to `main`, `master`, or `develop` branches
- Pull requests to `main` or `master`
- Manual trigger via **Actions** tab → **Run workflow**

### Manual Trigger

1. Go to **Actions** tab in GitHub
2. Select **Android Build & Sign** workflow
3. Click **Run workflow** button
4. Select branch and click **Run workflow**

---

## Step 4: Download Artifacts

After successful build:

1. Go to **Actions** tab
2. Click on the completed workflow run
3. Scroll to **Artifacts** section
4. Download:
   - `release-apk` - Universal APK
   - `release-apk-split` - Architecture-specific APKs
   - `release-aab` - App Bundle for Play Store

Artifacts are retained for **30 days**.

---

## Security Best Practices

### ✅ DO

- Keep your original keystore (`barakah-release.jks`) backed up securely
- Use strong, unique passwords
- Delete local keystore files after adding to GitHub Secrets
- Review workflow logs for any security issues

### ❌ DON'T

- Commit keystore files to Git (already in `.gitignore`)
- Share your passwords or Base64 keystore
- Print secrets in workflow logs
- Store keystore in plain text anywhere public

### Backup Your Keystore!

⚠️ **CRITICAL**: If you lose your keystore, you cannot update your app on the Play Store. Store backups in:

- Encrypted cloud storage (Google Drive, iCloud with encryption)
- Physical secure location (USB drive in safe)
- Password manager (1Password, Bitwarden)

---

## Troubleshooting

### Build fails with "Keystore not found"

Ensure `BARAKAH_BASE64_KEYSTORE` secret is set correctly. The Base64 should be a single line without line breaks.

### "Invalid keystore format"

The Base64 encoding may be corrupted. Regenerate the keystore and re-encode.

### "Alias does not exist"

Verify `BARAKAH_KEY_ALIAS` matches the alias generated by the script.

### "Wrong password"

Double-check `BARAKAH_KEY_PASSWORD` and `BARAKAH_STORE_PASSWORD` match what you entered during generation.

### Build succeeds but APK is unsigned

Ensure `key.properties` values are correct. The workflow creates this file from secrets.

### "keytool not found" during script execution

Install Java JDK and ensure `JAVA_HOME` is set:

```bash
# Check Java installation
java -version
keytool -help

# If not found, add to PATH (example for Windows)
# Add C:\Program Files\Java\jdk-17\bin to system PATH
```

---

## Workflow File Location

The GitHub Actions workflow is located at:

```
.github/workflows/android-build.yml
```

## Support

For issues with the build process, check:

1. GitHub Actions logs for detailed error messages
2. Flutter documentation: https://docs.flutter.dev/deployment/android
3. GitHub Actions documentation: https://docs.github.com/en/actions

---

**Last Updated**: December 2024

