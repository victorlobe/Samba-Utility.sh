# Samba Utility for macOS (Homebrew)

A simple interactive shell script to **start**, **stop**, **restart**, and **check the status** of Samba and NetBIOS services (`smbd` / `nmbd`) installed via [Homebrew](https://brew.sh) on macOS.

> Designed for macOS servers and Mac mini setups using Samba from `brew install samba`.

---

## 📦 Features

- Interactive menu to control Samba
- Starts both `smbd` and `nmbd` with your custom config
- Clean output with colors and status indicators
- Lightweight and dependency-free

---

## 🚀 Installation

1. **Install Samba (if not already):**
   ```bash
   brew install samba
   ```

2. **Download the script:**
   ```bash
   curl -o samba-utility.sh https://raw.githubusercontent.com/victorlobe/samba-utility.sh/
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
5) Exit
```

---

## 📁 Default Paths Used

- **Samba Config:** `/opt/homebrew/etc/smb.conf`
- **smbd binary:** `/opt/homebrew/sbin/samba-dot-org-smbd`
- **nmbd binary:** `/opt/homebrew/sbin/nmbd`

Make sure these match your Homebrew install. You can change them in the script if needed.

---

## 📄 License

MIT © [Victor Lobe]
