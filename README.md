# 📱 Android ROM Settings Extractor

*Read this in [Tiếng Việt](README-vi.md)*

A streamlined tool to automatically extract `Settings.apk` from Android OTA Payload ROMs. This project provides **two parallel operation methods**: a **Docker** version for the Linux ecosystem and a **Native Windows (PowerShell)** version that is extremely friendly for non-technical users.

## ✨ Key Features

- Independent support for 2 platforms: **Native Windows** or **Docker Container**.
- Automatically extracts `.zip` ROMs to get `payload.bin`.
- Automatically unpacks and extracts the `system_ext.img` partition.
- **Auto-Download Engine:** Automatically downloads `payload-dumper-go` on Windows if it doesn't exist.
- Extracts `Settings.apk` and automatically renames it based on the input ROM name: `Settings_{codename}_from_{version}.apk`
- Smart system that automatically cleans up gigabytes of temporary virtual partition data immediately after extraction to save your disk space.

---

## 📥 Preparation: Where to Get the ROM

Before running the tools, you need the official ROM file:
1. Visit [https://mifirm.net/](https://mifirm.net/).
2. Search for your specific device.
3. Download the **Recovery ROM** version. *(Note: Must be a `.zip` file! Do not download the Fastboot ROM `.tgz` as it has a different structural layout without the `payload.bin` core)*.

---



## 🚀 METHOD 1: EXTRACT ON NATIVE WINDOWS (RECOMMENDED)

This method utilizes Windows PowerShell combined with the power of **7-Zip**. You absolutely **do not need Docker** or virtual machine knowledge, and you won't have to worry about sudden C drive bloating.

### 🛠️ Requirements
- Windows 10/11 with Windows PowerShell.
- **Mandatory:** [7-Zip](https://www.7-zip.org/download.html) installed (Must be in the default location `C:\Program Files\7-Zip`).

### ⚙️ Usage (Just 1 command)
1. Place your ROM `.zip` file in this same directory (do not extract).
2. Open Terminal / PowerShell and run the following command for 100% automation:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\extract.ps1
```
*(💡 Tip: If you are typing this from Git Bash, make sure to change the backslash to a forward slash like `./extract.ps1`)*

The whole process of cracking the ROM -> Loading tool -> Extracting APK will run, and the final APK will be saved in the `settings_apks/` folder. Temporary files will be deleted automatically.

---

## 🐋 METHOD 2: EXTRACT VIA DOCKER (FOR LINUX/WSL2 USERS)

Uses a heavily isolated environment to avoid cluttering your host machine.

### 🛠️ Requirements
1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (WSL2 backend enabled).
2. **Make** command utility (Available on Git Bash, Linux/macOS).

### ⚙️ Usage
1. Keep the `.zip` file in this directory.
2. Build and create the container image architecture (Type only once):
   ```bash
   make build
   ```
3. Execute the command to let the machine automatically find the zip file and extract it:
   ```bash
   make extract
   ```
   *(If there are too many `.zip` files in the folder, specify it: `make extract ROM=filename.zip`)*.

---

## 🧹 PC Rescue & Fix C Drive Bloat (For Docker Users)

Running Docker on Windows to extract virtual disks can easily cause the intermediate `ext4.vhdx` WSL file to bloat significantly without shrinking back down.

Grasp these secrets to clean up your system:

- **1. Delete all temporary/invisible files after ROM extraction (keeps the Apk):**
  ```bash
  make clean
  ```

- **2. Release all Cache occupied by Docker:**
  ```bash
  make prune
  ```
  Hard shut down the WSL2 core to force Windows to free up RAM/Storage:
  ```bash
  make shutdown
  ```

> ⚠️ **The Ultimate DiskPart Trick to shrink C Drive**:
> If your C drive has drastically lost tens of GBs, open PowerShell as **Administrator**, type `diskpart` > Select the file by typing `select vdisk file="path/to/ext4.vhdx"` > Lock the drive by typing `attach vdisk readonly` > Finally, squeeze it by typing `compact vdisk`. Your drive will be spacious again.
