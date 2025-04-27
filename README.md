# Samba Utility for macOS (Homebrew)

A simple interactive shell script to **start**, **stop**, **restart**, and **check the status** of Samba and NetBIOS services (`smbd` / `nmbd`) installed via [Homebrew](https://brew.sh) on macOS.

> Designed for macOS servers or home network setups using Samba from `brew install samba`.

---

## 📦 Features

- Interactive menu to manage Samba services
- Automatically detects Homebrew install location
- Asks to install Samba via Homebrew if not found
- Start, stop, restart `smbd` and `nmbd` easily
- Check and display running status of both services
- Show last 20 lines of the Samba log file
- Validate your `smb.conf` file (syntax test)
- Create timestamped backups of `smb.conf`
- Start `smbd` manually in debug mode with increased logging
- Open `smb.conf` location directly in Finder
- Colored output for better readability
- Status indicators (✅ / ❌) for quick overview
- Clean error handling and feedback if something fails
- Lightweight and dependency-free (pure bash)

---

## 🚀 Installation

1. **Install Samba (if not already):**
   ```bash
   brew install samba
   ```

2. **Download the script:**
   ```bash
   curl -o samba-utility.sh https://raw.githubusercontent.com/victorlobe/Samba-Utility.sh/main/Samba%20Utility.sh
   ```

3. **Make it executable:**
   ```bash
   chmod +x samba-utility.sh
   ```

4. *(Optional)* Move it into your `$PATH`:  
   ```bash
   sudo mv samba-utility.sh /usr/local/bin/samba-utility
   ```

---

## ⚙️ Usage

Just run:

```bash
./samba-utility.sh
```

Or if you moved it globally:

```bash
samba-utility
```

You’ll see an interactive menu like this:

```
== Samba Utility ==
Choose an option:
1) Start Samba
2) Stop Samba
3) Restart Samba
4) Show Status
5) Show Last Logs
6) Show config file in Finder
7) Backup Configuration
8) Test Configuration
9) Run in Debug Mode
10) Exit
```

---

## 📁 Default Paths Used

- **Samba Config:** `/opt/homebrew/etc/smb.conf`
- **smbd binary:** `/opt/homebrew/sbin/samba-dot-org-smbd`
- **nmbd binary:** `/opt/homebrew/sbin/nmbd`
- **Samba Logs:** `/opt/homebrew/var/log/samba/log.smbd`

*(These paths can be customized at the top of the script if needed.)*

---

## 📄 License

MIT © Victor Lobe
