# AHK Image Viewer from Base64

Yet another useless program I wrote using AutoHotKey. Basically, it can view an Image from Base64 text file. It decodes base64-encoded image data and displays it in an always-on-top GUI window.

## Overview

This script embeds base64-encoded image data in an `.txt` file (see the [samples](https://github.com/itsShiroharu/AHK-Image-Viewer-from-Base64/blob/main/samples/Base64.txt) here), decodes it, converts it to a JPG image, and displays it in a clean, floating window.

## Features

- **Base64 Decoding**: Uses Windows CryptoAPI (`Crypt32.dll`). It may trigger Windows Defender
- **Automatic Cleanup**: Removes temporary files when the window is closed
- **No External Dependencies**: Uses only built-in Windows APIs and AutoHotkey

## Requirements

- AutoHotkey v1.1
- Windows OS
- An `.txt` file containing base64-encoded image data

## How It Works

| Step | Action |
|------|--------|
| **1. Initialization** | Installs embedded `.txt` file to system temp directory |
| **2. GUI Setup** | Creates a 540×540 pixel always-on-top window |
| **3. Decoding** | Reads base64 data from `Base64.txt` |
| **4. Conversion** | Uses `Base64ToImage()` function to decode and save as JPG |
| **5. Display** | Shows decoded image in the GUI window |
| **6. Cleanup** | Removes temporary files on window close |


## Usage

### Basic Setup

```autohotkey
#NoEnv
#SingleInstance Force

; Compile with base64 image data embedded in Base64.txt
FileInstall, Base64.txt, %A_Temp%\Base64.txt, 1

; Create and show GUI
Gui, +AlwaysOnTop -Resize
Gui, Add, Picture, x0 y0 w540 h540 vDisplayPic
Gui, Show, w540 h540, %filename%

; ... rest of script
```

### Creating the Base64.txt File

Generate base64-encoded image data and save it to `Base64.txt` in your script directory. You can encode an image using:

**PowerShell:**
```powershell
[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("path\to\image.jpg")) | Out-File Base64.txt
```

**Online:** Just search online "Image to Base64"

## Functions

### `Base64ToImage(ByRef b64, path)`

Decodes base64 string to binary and writes it to a file.
 
| Parameter | Type | Description |
|-----------|------|-------------|
| `b64` | string (by reference) | Base64-encoded image data |
| `path` | string | Output file path for the decoded image |

**How It Works:**

| Step | Description |
|------|-------------|
| 1 | Calls `CryptStringToBinary` to get required buffer size |
| 2 | Allocates buffer and decodes base64 data into it |
| 3 | Opens output file and writes raw binary data |
| 4 | Closes the file |

## Customization

### Window Size
Change the dimensions in the GUI setup:
```autohotkey
Gui, Add, Picture, x0 y0 w800 h600 vDisplayPic
Gui, Show, w800 h600, My Image Viewer
```

### Window Title
Modify the title parameter:
```autohotkey
Gui, Show, w540 h540, Custom Window Title
```

## Cleanup

When the GUI window is closed, the script automatically:
- Deletes `Base64.txt` from temp directory
- Deletes the decoded `index.jpg` from temp directory
- Exits the application

## Compiling to Executable (for distributing, dependency-free)

- Uses Ahk2Exe (Pre-installed when Installing AHK into Windows)
- You can customize the ``.exe`` icon using ``.ico``, and choose the Base File. It's recommended to use U64
- You can use compression, either MPRESS, UPX, or no compression at all

## Certify the Exe (Self-Signed, Optional)

You can sign your own Exe compiled using ``Ahk2Exe`` tool before. Steps is pretty straightforward. First is to create the certificates:
```shell
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "CN=YOUR_NAME_HERE,E=YOUR_EMAIL_HERE" -KeyUsage DigitalSignature -Type CodeSigningCert -FriendlyName "APP_NAME_HERE" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3"); Export-PfxCertificate -Cert $cert -FilePath "C:\cert.pfx" -Password (ConvertTo-SecureString -String "YOUR_PASSWORD_HERE" -AsPlainText -Force) -Force
```

Then, sign the executable with Signtool:
```shell
signtool sign /fd SHA256 /f "C:\cert.pfx" /p "YOUR_PASSWORD_HERE" /t http://timestamp.digicert.com /v "C:\Users\Administrator\Documents\GitHub\Project\dist\index.exe"
```


## Notes

| Note | Explanation |
|------|-------------|
| `#NoEnv` | Improves performance by not initializing environment variables |
| `#SingleInstance Force` | Ensures only one instance of the script runs at a time |
| `-Resize` flag | Prevents window resizing |
| Temp directory | Temporary files are stored in `%A_Temp%` |
| Memory operations | Uses Unicode-safe memory operations via DllCall |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **Image not displaying** | Verify `Base64.txt` contains valid base64 data; Check that image format is supported (JPG recommended); Ensure temp directory has write permissions |
| **Script errors** | Run as Administrator if temp directory access is denied; Confirm AutoHotkey v1.1 is installed; Check Windows event logs for CryptoAPI errors |


## License

Project is Licensed under MIT License. See [here](https://github.com/itsShiroharu/AHK-Image-Viewer-from-Base64/blob/main/LICENSE) for the license.
