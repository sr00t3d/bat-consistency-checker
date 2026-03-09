# DNS Consistency Checker

Readme: [BR](README-ptbr.md)

![License](https://img.shields.io/github/license/sr00t3d/bat-consistency-checker) ![Bat Script](https://img.shields.io/badge/language-Bash-green.svg)

<img width="700" src="bat-consistency-checker-cover.webp" />

A Windows Batch Script (`.bat`) tool designed to diagnose DNS name resolution and propagation issues, specifically focusing on mail servers (`mail.domain`).

This script performs cross-referenced queries between the machine's Local DNS, Google's Public DNS, and the network's Public IP to validate if the client is resolving the correct server IP address.

## Features

* **Cache Flush:** Automatically executes `ipconfig /flushdns` to ensure no stale data is affecting the test.
* **Cross-Reference Checks:**
    * Queries the `mail` subdomain IP via **Google DNS (8.8.8.8)**.
    * Queries the `mail` subdomain IP via **Local DNS** (the resolver configured on the network adapter).
* **Public IP Identification:** Checks the client's external IP address using the OpenDNS service.
* **Automatic Diagnosis:** Compares the locally resolved IP against the externally resolved IP and alerts the user if there is a mismatch (indicating propagation delays or stuck cache).

## Prerequisites

* **Operating System:** Windows (7, 8, 10, or 11).
* **Permissions:** Recommended to run as **Administrator** to ensure the DNS flush command works correctly, though the query functions work in user mode.

## How to Use

1.  Download the script file (e.g., `dns-checker.bat`).
2.  Right-click the file and select **"Run as administrator"**.
3.  Wait for the initialization (5 seconds).
4.  When prompted, enter only the main domain name.
    * *Example:* If your site is `www.company.com`, type `company.com`.
5.  The script will automatically append the `mail.` prefix and run the diagnostics.

## Understanding the Results

The script will display a summary at the end of the execution:

| Field | Description |
| :--- | :--- |
| **IP (resolved by 8.8.8.8)** | The IP address the world (Google) sees for your domain. |
| **IP (resolved by Local DNS)** | The IP address **your computer** is currently seeing. |
| **Client Public IP** | Your current internet connection's external IP address. |

### Possible Diagnoses:

* ✅ **[OK]:** The IP your computer sees matches the IP Google sees. Your DNS is updated and consistent.
* ⚠️ **[ALERT]:** The Local IP differs from the Google IP. This indicates:
    * DNS propagation has not finished yet;
    * Your ISP has an outdated cache;
    * There is an incorrect entry in the Windows `hosts` file.

## Code Logic Example

The core consistency check follows this logic:

```batch
if "!IP_LOCAL!"=="!IP_SERVIDOR!" (
    echo [OK] The locally resolved IP matches the IP returned by the server.
) else (
    echo [ALERT] The locally resolved IP DOES NOT match the IP returned by the server.
)
```

## Legal Notice

> [!WARNING]
> This software is provided "as is". Always make sure to test first in a development environment. The author is not responsible for any misuse, legal consequences, or data impact caused by this tool.

## Requirements

- **OS**: Linux (Debian, Ubuntu, CentOS, RHEL).
- **Dependencies**: `bash`, `curl`, `python3` (for the internal conversion engine).
- **Permissions**: Read access to the source Maildir and write access to the destination.

## Detailed Tutorial

For a complete step-by-step guide, check out my full article:

👉 [**Check your Doman and DNS Quickly**](https://perciocastelo.com.br/blog/check-your-domain-and-dns-quickly-in-cmd.html)

## License

This project is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for details.