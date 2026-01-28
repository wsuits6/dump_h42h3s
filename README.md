# HashDump
```
██╗    ██╗███████╗██╗   ██╗██╗████████╗███████╗ ██████╗ 
██║    ██║██╔════╝██║   ██║██║╚══██╔══╝██╔════╝██╔════╝ 
██║ █╗ ██║███████╗██║   ██║██║   ██║   ███████╗███████╗
██║███╗██║╚════██║██║   ██║██║   ██║   ╚════██║██╔═══██╗
╚███╔███╔╝███████║╚██████╔╝██║   ██║   ███████║╚██████╔╝
 ╚══╝╚══╝ ╚══════╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ 
```

## Overview
Windows batch tool that extracts SAM, SYSTEM, and SECURITY registry hives to a USB drive for offline hash analysis.

## What It Does
Dumps Windows password hashes by saving:
- `SAM` - User account hashes
- `SYSTEM` - Boot key for decryption
- `SECURITY` - Cached domain credentials

## Requirements
- Windows (7/8/10/11/Server)
- USB drive labeled **Hsociety**
- Administrator privileges

## Usage
1. Insert USB labeled `Hsociety`
2. Run `HashDump.bat` as Administrator
3. Registry hives saved to: `Hsociety:\HashDumps\<hostname>_<timestamp>\`

## Post-Processing
Extract hashes using:
```bash
# Impacket secretsdump
python3 secretsdump.py -sam SAM -system SYSTEM -security SECURITY LOCAL

# Or use mimikatz, hashcat, john, etc.
```

## Output Structure
```
HashDumps/
└── HOSTNAME_YYYY-MM-DD_HH-MM-SS/
    ├── SAM
    ├── SYSTEM
    └── SECURITY
```

## ⚠️ DISCLAIMER
**FOR AUTHORIZED SECURITY RESEARCH AND LAB ENVIRONMENTS ONLY**

This tool extracts Windows credential material. Unauthorized use is illegal.

**Legal Use Cases:**
- Authorized penetration testing
- Security research in isolated labs
- Red team exercises with written permission
- Personal systems you own

**Illegal Activities:**
- Unauthorized credential theft
- Corporate espionage
- Identity theft
- System compromise without permission

Violates: Computer Fraud and Abuse Act (CFAA), GDPR, local laws.

**The author assumes NO responsibility for misuse.**

## Author
**Wsuits6** - Security research tooling