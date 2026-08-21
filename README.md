<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/monatemedia/docker-engine-on-linux">
    <img src="images/logo.svg" alt="Logo" width="80" height="80">
    
  </a>

<h3 align="center">Docker Engine On Linux</h3>

  <p align="center">
    A set of scripts to help you host your side projects on VPS using Linux and Docker.
    <br />
    <a href="https://github.com/monatemedia/docker-engine-on-linux"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/monatemedia/docker-engine-on-linux">View Demo</a>
    ·
    <a href="https://github.com/monatemedia/docker-engine-on-linux/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/monatemedia/docker-engine-on-linux/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#technology-stack">Technology Stack</a></li>
    <li>
      <a href="#buy-a-domain-and-set-up-email">Buy a Domain and Set Up Email</a>
      <ul>
        <li><a href="#buy-a-domain">Buy a Domain</a></li>
        <li><a href="#decide-where-dns-lives">Decide Where DNS Lives</a></li>
        <li><a href="#set-up-email">Set Up Email</a></li>
        <li><a href="#managing-a-domain-email-and-vps-across-different-companies">Managing a Domain, Email, and VPS Across Different Companies</a></li>
      </ul>
    </li>
    <li><a href="#choose-a-vps">Choose A VPS</a></li>
    <li><a href="#vps-settings">VPS Settings</a></li>
    <li><a href="#log-into-vps">Log Into VPS</a></li>
    <li><a href="#install-git">Install Git</a></li>
    <li><a href="#create-new-user-with-denlin-cli">Create New User With Denlin-CLI</a></li>
    <li><a href="#set-up-passwordless-ssh-login">Set Up Passwordless SSH Login</a></li>
    <li><a href="#install-docker-engine">Install Docker Engine</a></li>
    <li><a href="#set-up-nginx-proxy">Set Up Nginx Proxy</a></li>
    <li><a href="#set-up-your-first-container">Set Up Your First Container</a></li>
    <li><a href="#install-the-github-cli-gh">Install the GitHub CLI (<code>gh</code>)</a></li>
    <li><a href="#publish-your-first-project">Publish Your First Project</a></li>
    <li><a href="#create-dockerfile">Create Dockerfile</a></li>
    <li><a href="#build--run-the-container-in-docker-desktop">Build & Run the Container in Docker Desktop</a></li>
    <li><a href="#create-a-github-personal-access-token-pat">Create a GitHub Personal Access Token (PAT)</a></li>
    <li><a href="#log-into-github-with-the-github-cli">Log into GitHub with the GitHub CLI</a></li>
    <li><a href="#initialize-github-repository">Initialize GitHub Repository</a></li>
    <li><a href="#store-pat-as-a-github-actions-secret">Store PAT as a GitHub Actions Secret</a></li>
    <li><a href="#store-docker-image-to-github-container-registry">Store Docker Image to GitHub Container Registry</a></li>
    <li><a href="#create-a-docker-compose-file">Create A Docker Compose File</a></li>
    <li><a href="#create-a-github-actions-cicd-pipeline">Create A GitHub Actions CI/CD Pipeline</a></li>
    <li><a href="#deploying-multiple-environments-staging--production">Deploying Multiple Environments (Staging & Production)</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://github.com/monatemedia/docker-engine-on-linux)

<p align="center">Denlin: Docker Engine On Linux CLI Tool Screenshot</p>


The Problem: I have one VPS with a single IP address. I want to be able to experiment with different programming languages and host my various side projects on my single VPS. 

The technology stack:

* Ubuntu Linux Operating System
* Docker Containers
* Github Version Control
* Github Actions CI/CD Pipeline
* Nginx Reverse Proxy Server
* Let's Encrypt SSL Certificate
* Performance Monitoring Tools
* Reverse Proxy
* Dockerfile Templates
* Docker Compose Templates


Self hosting done right can reduce the cost of hosting, but introduces additional complexity which will cost you taking longer to launch. 

The "Denlin Docker Engine on Linux CLI Tool" is a set of scripts to help DevOps beginners get their VPS set up quickly with Linux and Docker, using these scripts.

The Set Up: In my directory root, I have these apps:

* /svelte-counter
* /python-django-achievementhq

I want to be able to run all my apps at the same time on my VPS.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Technology Stack


### Hostinger Virtual Private Server Hosting

My VPS hosting is provided by Hostinger, but you may choose any VPS host.


### Ubuntu Linux Operating System

Tested on Ubuntu 22.04 and Ubuntu 24.04 LTS

[![Ubuntu][Ubuntu.com]][Ubuntu-url]


### Docker

Docker hosts applications inside of docker containers

[![Docker][Docker-hub]][Docker-hub-url]


### Github Version Control

Version control provided by GitHub.

[![Github][Github]][Github-url]


### Github Actions CI/CD Pipelines

Github Actions for Continuous Integration/Continuous Delivery pipelines

[![Github Actions][Github Actions]][Github-Actions-url]


### Nginx Reverse Proxy Server

Nginx as the HTTP web server, reverse proxy and content cache. 

[![Nginx][Nginx]][Nginx-url]


### Let's Encrypt SSL Certificate

Let's Encrypt Nginx Companion provides SSL Certificates.

[![Lets-Encrypt][Lets-Encrypt]][Lets-Encrypt-url]


### Htop System Monitoring

`htop` provides interactive process viewing and system monitoring.

[![Htop][Htop.dev]][Htop-url]


### Client-Side Framework Docker Templates

[![Angular][Angular.dev]][Angular-url]
[![React][React.dev]][React-url]
[![Vue][Vuejs.org]][Vue-url]
[![Next][Next.org]][Next-url]
[![Nuxt][Nuxt.net]][Nuxt-url]
[![Svelte][Svelte.dev]][Svelte-url]
[![HTML5][HTML5]][HTML5-url]
[![CSS3][CSS3]][CSS3-url]
[![JavaScript][JavaScript]][JavaScript-url]


### Server-Side Framework Docker Templates

[![Python][Python.org]][Python-url]
[![Django][Djangoproject.com]][Django-url]
[![Gunicorn][Gunicorn]][Gunicorn-url]
[![FastAPI][FastAPI.dev]][FastAPI-url]
[![Flask][Flask.dev]][Flask-url]
[![Streamlit][Streamlit.net]][Streamlit-url]
[![PHP][Php.net]][Php-url]
[![WordPress][WordPress.net]][WordPress-url]
[![Laravel][Laravel.com]][Laravel-url]


### SQL Database Docker Templates


[![MySQL][MySQL.com]][MySQL-url]
[![Postgres][Postgres.com]][Postgres-url]
[![MongoDB][MongoDB.com]][MongoDB-url]
[![MariaDB][MariaDB.org]][MariaDB-url]
[![Redis][Redis.io]][Redis-url]
[![SQLite][SQLite.org]][SQLite-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- DOMAIN AND EMAIL -->
## Buy a Domain and Set Up Email

Before you touch a VPS, sort out your domain and email. Both are faster and cheaper to get right at the start than to migrate later, and a couple of decisions here (mainly: where does DNS actually live?) shape everything that follows.

### Buy a Domain

Domains are registered through a domain registrar. Depending on where you are and what you're registering, this might be a local registrar (e.g. Axxess for South African `.co.za` domains), an international one (Namecheap, GoDaddy, Google Domains), or your VPS host itself if they also sell domains. Search for the name you want, confirm it's available, and buy it.

> [!TIP]
> Some registrars ask you to choose a DNS setup during checkout — often something like "park on our own DNS panel" (sometimes for a monthly fee) versus "use your own nameservers" (usually free). If you plan to manage DNS at your VPS host instead, as recommended below, choose the free option — you'll fill in the actual nameserver values once your host tells you what they are.

### Decide Where DNS Lives

Every domain needs exactly one authoritative place for its DNS records — the source of truth for what `@`, `www`, `mail`, and anything else under your domain actually points to. You have two broad options:

1. **Keep DNS at your registrar** and manually add individual records (A, MX, etc.) pointing at whatever services you use elsewhere.
2. **Delegate DNS to your VPS host** by updating your domain's nameservers at the registrar to your host's nameservers, then manage all records from your host's control panel instead.

This project's own setup uses option 2, because our VPS and email both live at Hostinger — one dashboard, one place to look. If you're deliberately spreading domain, email, and VPS across different companies (see below), option 1 can actually be simpler, since your registrar becomes the one shared place every provider's setup instructions point back to. Either is fine — just pick one on purpose rather than ending up there by accident.

> [!IMPORTANT]
> ### Nameservers can be domain-specific, not account-wide
> Don't assume the nameservers you see for one domain apply to every domain on the same hosting account. Start your host's own "connect an external domain" flow and use the exact nameservers *it* gives you for *that* domain — some hosts assign a unique nameserver pair per domain connection, which can differ from a pair already in use elsewhere on the same account.

Once you've updated the nameservers at your registrar, propagation can take anywhere from a few minutes to 24 hours. Check progress with a DNS checker such as [dnschecker.org](https://dnschecker.org) rather than guessing — most of the steps later in this guide will silently fail to detect your domain until propagation has actually finished.

### Set Up Email

Decide what mailboxes your project actually needs before creating any. Two are usually enough to start:

- A **transactional sending address** (e.g. `noreply@yourdomain.com`) — used by your app to send confirmation emails, password resets, invoices, and the like, typically via a service like Amazon SES rather than the mailbox's own SMTP.
- A **support/contact address** (e.g. `support@yourdomain.com`) — for anything a real person needs to read: user replies, data/privacy requests, general enquiries.

If your project already has draft privacy policy or terms of service documents, check them first — they often already specify (or should specify) exactly which addresses they promise to use, so you're not guessing at what to create.

> [!CAUTION]
> ### Generate passwords, don't invent them
> For anything you'll type by hand occasionally — an email account password, a personal login — use a passphrase generator such as [useapassphrase.com](https://www.useapassphrase.com/) rather than making one up yourself. It produces long, random, but memorable word combinations that are both stronger and easier to type on a phone than something like `Tr0ub4dor&3`. For secrets you'll never type by hand (like a VPS root password, which you'll paste from a password manager), your provider's own "Generate" button is fine — it doesn't need to be memorable.

### Managing a Domain, Email, and VPS Across Different Companies

It's common for your domain, email, and VPS to end up with three different companies — a local registrar for the domain, Google Workspace or your host's own product for email, a different provider entirely for the VPS. This isn't a mistake, and plenty of production setups look exactly like this. It does mean a few things are worth doing on purpose:

- **One provider has to be the DNS authority** (see "Decide Where DNS Lives" above). Choose deliberately rather than by accident.
- **Problems take longer to diagnose** when providers don't talk to each other. If email stops arriving, the fault could be at your registrar's DNS, your DNS host's MX records, or your email provider itself — expect to check each in turn rather than assuming it's the last thing you touched.
- **Write down what lives where.** A short note — "domain: Axxess, DNS: Hostinger, email: Hostinger, VPS: Hostinger" — saves real time later, especially if you're not the one debugging it next time.

> [!TIP]
> ### Ask your provider's AI assistant, if they have one
> Some hosts now offer an AI support assistant that can look up account details or even make changes directly — Hostinger's **Kodee** is a strong example, and noticeably ahead of most competitors at the time of writing. If your provider has something similar, it's often faster than digging through an unfamiliar panel yourself: ask plainly for what you need (e.g. "what nameservers does my account use for domain X"), and have it confirm exactly what it's about to change before it does anything.
>
> If you're on a smaller or budget host, don't assume they have an equivalent — and if they do, don't assume it's as capable as Kodee. Verify anything an AI assistant tells you or does against an independent source (a DNS checker, the panel itself), the same way you would for a human support agent.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LOG INTO VPS -->
## Choose A VPS

I have chosen Hostinger


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## VPS Settings

In your hosting provider's control panel, you'll want to chose an operating system for your VPS.

-  Choose a location closest to your customers
-  Choose Plain OS, not an OS with a control panel
-  Choose Ubuntu for your operating system
-  Choose a VPS hostname(optional)
-  Set a secure root password of at least 12 characters
-  We can skip creating an SSH Key as we will create that later(if provided)


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Log Into VPS

-  In your hosting services control panel, find your IP address for your VPS
-  On your local machine go to your terminal client. 
 

> [!TIP]
> ## Git Bash
> Git Bash is an application which provides an emulation layer for a Git command line experience. Windows users should use the Git Bash terminal client for every local-machine step in this guide, unless a step explicitly says otherwise.
> Mac users can use their native command line shells, provided they have Git installed.
>
> A handful of steps later on (managing a Windows service, for example) need something Git Bash can't do on its own — those steps will explicitly say **PowerShell as Administrator** and are the exception, not the norm. Once that specific step is done, go straight back to Git Bash for everything else.


Log into your VPS


```sh
ssh root@your_ip_address
```


If it's your first time logging in, you will get this message that you must accept by typing `yes` followed by the enter button, before being allowed to log in.


```sh
The authenticity of host 'your_ip_address' can`t be established.
RSA Key fingerprint is SHA265:a_hashed_value_here
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```



After key fingerprint has been added to your local environment, the terminal will ask you for your password.


```sh
Warning: Permanently added 'your_ip_address' (RSA) to the list of known hosts.
root@your_ip_address`s password: your_password_goes_here
```


You should now be logged in.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Install Git

### 1. Update Your Package Index

Before installing Git, ensure your system is up-to-date:


```sh
apt update && apt upgrade -y

```


### 2. Install Git


```sh
apt-get install --reinstall git -y

```

> [!WARNING]
> ### Force a reinstall rather than a plain install
> On at least one fresh Hostinger Ubuntu 24.04 image, a plain `apt-get install git` reported `git is already the newest version` and `git --version` still failed with `command not found` right after. `--reinstall` costs nothing extra when the package is genuinely fine, and rules out a broken/incomplete package as the cause if `git --version` still fails in the next step — see the note there for what to do if it does.


### 3. Verify Installation

Once installed, verify the version of Git to ensure it’s installed correctly:


```sh
git --version

```


You should see an output like:


```sh
git version 2.x.x
```

> [!TIP]
> ### If this still says "command not found," don't reboot — try `hash -r` first
> Even after a successful (re)install, `git --version` can still report `command not found` for a strange reason: bash caches where it found a command earlier in the session (`hash`), and that cache can go stale across an install. The tell is that `which git` and `type git` both correctly report `/usr/bin/git`, and running `/usr/bin/git --version` by full path works fine — it's specifically the bare `git` command that fails. If you see that pattern, this fixes it:
> ```sh
> hash -r && git --version
> ```
> This is unrelated to the "Pending kernel upgrade" reboot mentioned elsewhere in this guide — don't reach for a reboot here, `hash -r` is instant and this is a shell-session issue, not a system one.


### 4. Reboot Server

You can now reboot the server to load the new kernel.


```sh
sudo reboot

```

Wait about 30 seconds, then reconnect with your root user.

> [!NOTE]
> ### If `reboot` itself says "command not found," don't read too much into it
> On the same freshly-upgraded VPS, the `reboot` command can briefly report `command not found` right after a large `apt upgrade` — before any reboot has actually happened. It's tempting to conclude "the update broke `reboot`, and rebooting fixed it," but that can't be the real explanation: a reboot is *caused* by `reboot` succeeding, so it can't already have happened before the command that triggers it ever ran. If a retry of the exact same command succeeds moments later with no other action taken in between, nothing rebooted the system in the interim — the fix wasn't "reboot," it was just re-running the command (or `hash -r`, same family of issue as the Git note above).
>
> A more likely explanation: `apt upgrade` had flagged several service restarts as deferred (`dbus.service`, `systemd-logind.service`, `unattended-upgrades.service` in this run) rather than applying them immediately, and that kind of in-flight state after a big upgrade can cause transient command-lookup failures that clear themselves within moments. Treat "command not found" right after an upgrade as a signal to retry or run `hash -r`, not as evidence that a reboot was required to fix it — the reboot you're about to do here is for the new kernel, not for this.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Create New User With Denlin-CLI

### Log into your VPS as Root User


```sh
ssh root@your_ip_address
```


### Clone and install the Denlin repository.


```sh
git clone https://github.com/monatemedia/docker-engine-on-linux.git
cd docker-engine-on-linux
bash install.sh
cd ~

```


### Create A New User


```sh
denlin create-new-user

```

After the new user has been created, log out of the VPS and then log in with your new user account.


### Log into your VPS As New User

Log back into your VPS with the new user account you just created


```sh
ssh user@your_ip_address
```


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Set Up Passwordless SSH Login

Whenever logging into your VPS from your local computer, you will always be asked for your username `ssh your_name@your_ip_address` and your password. This is fine but can be annoying if you have already secured your personal computer with a strong password.

We have the option to in future be able to log into the VPS with only our username using an SSH key-pair.


> [!IMPORTANT]
> 
> ## Linux SSH Key Pairs
> 
> RSA encryption is **a public-key cryptographic system known for its reliable encryption and decryption method**. Typically, RSA is used for encryption of shared keys exchanged over the internet to establish a secure connection. RSA encryption has different key sizes which range from 1024 to 4096 bits.
> 
> A SSH key pair in Linux is **a combination of a public key and a private key that are used to authenticate a remote user to an SSH server.** 
> 
> -  Public Key
> 	-  Used to encrypt data and can be shared with any SSH server
> - Private Key
> 	-  Used to decrypt data and should be kept secret and encrypted


Run this command and follow the prompts


```sh
denlin setup-ssh-login

```

You'll be asked for a passphrase while the key is being generated. Use a strong one — a passphrase generator like [useapassphrase.com](https://www.useapassphrase.com/) works well. A key with no passphrase is just as usable to anyone who ever gets a copy of the file itself (a stolen laptop, a leaked backup, malware quietly reading your disk) as it is to you, so it's worth the few extra seconds now.

### Use an SSH Agent (So You Only Enter Your Passphrase Once)

Typing a passphrase on every single `ssh` or `scp` call gets old fast — but you don't have to give up the passphrase to get that convenience back. An SSH agent is a small background service that holds your *unlocked* key in memory after you enter the passphrase once — it's never written back to disk — and quietly answers on your behalf for every SSH connection after that, for as long as it keeps running. In practice: one passphrase prompt after you log into your computer, then passwordless-feeling SSH for the rest of that session.

On Windows, the agent ships with OpenSSH but is off by default. One-time setup, in PowerShell **as Administrator**:

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
```

Then, once per login session, in Git Bash:

```sh
ssh-add ~/.ssh/id_ed25519
```

You'll be asked for the passphrase this one time. After that, `ssh user@your_ip_address` should connect straight through with no prompt at all — until you log off, reboot, or restart the agent, at which point you'll `ssh-add` again.

> [!WARNING]
> ### "Could not open a connection to your authentication agent"
> Git Bash ships its own bundled build of OpenSSH (you can check with `which ssh-add` — if it points at `/usr/bin/ssh-add`, this is what's happening), and that build doesn't know how to talk to the Windows `ssh-agent` service's named pipe, even once the service is running. The fix is to tell Git Bash to prefer Windows' own native OpenSSH client, which does speak to it — both builds read and write the same `~/.ssh` folder, so nothing about your keys changes:
> ```sh
> echo 'export PATH="/c/Windows/System32/OpenSSH:$PATH"' >> ~/.bashrc
> source ~/.bashrc
> which ssh-add
> ```
> That last command should now print `/c/Windows/System32/OpenSSH/ssh-add.exe`. Re-run `ssh-add ~/.ssh/id_ed25519` and it should connect to the agent this time.

On macOS and most Linux desktops, an agent is already running by default, and `ssh-add ~/.ssh/id_ed25519` (macOS: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519` to persist it across restarts) is generally all you need — no service to enable first.

> [!NOTE]
> An SSH agent protects against your key file leaking on its own — a backup, a stolen drive, malware reading your files. It doesn't protect against someone with live access to your already-unlocked machine while the agent has the key loaded; at that point they can use the agent directly without ever needing the passphrase. That's a much narrower window than "anyone who ever gets the file, forever," which is what a passphrase-less key exposes you to — and it's why the passphrase is worth having even though disabling password login (next section) already closes off remote guessing attacks on its own.

> [!TIP]
> ### `sudo` wants your account password, not your key's passphrase
> Once you're used to typing a passphrase to unlock your key, it's an easy autopilot mistake to type that same passphrase into a `sudo` prompt moments later on the server — they're two different secrets, asked by two very similar-looking prompts, close together in time. `sudo` on the VPS always wants the Linux account password for the user you're logged in as (the one you set with `chpasswd` back when the user was created), never the SSH key passphrase. If `sudo` keeps rejecting a password you're sure is right, this mix-up is the first thing to check.

### Disable Password Login

Once you've confirmed `ssh user@your_ip_address` connects with your key, the account password is still a valid way to log in too — key-based login being available doesn't turn password login off. Anyone who ever guesses, phishes, or brute-forces that password can still get in the same way you could before you set up a key at all. Turning password auth off closes that door entirely, so the key becomes the only way in.

> [!WARNING]
> A mistake in `sshd_config` can lock you out of the server entirely, with no password fallback left to recover it. Do not skip the backup step, do not close your current terminal session until you've verified a *new* connection works in a separate window, and if anything looks wrong, you still have this session open to fix it in.

**1. Back up the files you're about to change:**

```sh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

> [!IMPORTANT]
> ### Cloud VPS images often override `sshd_config` from a separate file
> Many providers' Ubuntu cloud images (Hostinger included) ship `Include /etc/ssh/sshd_config.d/*.conf` near the top of `sshd_config`, plus a drop-in file in that folder that explicitly sets `PasswordAuthentication yes` — usually so the password the provider generated for you works on your very first login. sshd applies the *first* value it finds for a given setting and ignores later ones, and an early `Include` means the drop-in file wins over anything you edit further down in the main file. Editing `sshd_config` alone can look like it worked and change nothing.
>
> Check for this before editing anything:
> ```sh
> sudo grep -n "Include" /etc/ssh/sshd_config
> ls -la /etc/ssh/sshd_config.d/
> sudo grep -rniE "PasswordAuthentication|PermitRootLogin" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
> ```
> If a file in `sshd_config.d/` sets `PasswordAuthentication yes`, that's the one that actually needs to change — back it up too:
> ```sh
> sudo cp /etc/ssh/sshd_config.d/50-cloud-init.conf /etc/ssh/sshd_config.d/50-cloud-init.conf.bak
> ```
> (filename may differ depending on your provider — use whatever the grep above turned up).

**2. Make the change** — adjust the filename in the first command to match whatever your own grep found:

```sh
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config.d/50-cloud-init.conf
sudo sed -i -e 's/^#PasswordAuthentication yes/PasswordAuthentication no/' -e 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
```

The second command also turns off root login entirely. From here on, admin work happens by logging in as your regular user and using `sudo`, not by logging in as root directly — worth doing even if you're not disabling passwords, since a keyless, password-only root account is the single most attractive target on the whole server.

**3. Verify the edits landed, and check the config is valid:**

```sh
sudo grep -rniE "PasswordAuthentication|PermitRootLogin" /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
sudo sshd -t
```

`sshd -t` printing nothing at all is success — it only prints output when something's wrong.

**4. Reload (not restart) so the change takes effect without dropping your current connection:**

```sh
sudo systemctl reload ssh
```

**5. Leaving this session open, open a brand-new terminal window and confirm:**

```sh
ssh user@your_ip_address
```

connects via your key with no password ever offered, and:

```sh
ssh root@your_ip_address
```

is refused immediately with no password prompt at all. Only once both check out in the new window should you close the original session.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Install Docker Engine

To install Docker Engine, use the following command:


```sh
denlin docker-install

```

If you did not get the `Hello from Docker!` message, you can test your installation by running:

```sh
docker run hello-world

```

> [!NOTE]
> When this finishes successfully, it ends by force-closing your terminal session — that's intentional, not a crash. Your user was just added to the `docker` group, and Linux only picks that up on your next login, so the script logs you out to make sure it takes effect. Just log back in and carry on; running `docker` commands without `sudo` should work from here.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Set Up Nginx Proxy

You can use a single, centralized nginx-proxy container to manage your applications. This container will act as a reverse proxy and route traffic based on the subdomain to the correct application.

> [!IMPORTANT]
> 
> ## Docker Networking
> 
> Our containers on Docker do not communicate via ports and IP addresses as in traditional networking, but instead use Docker's built-in networking feature, where containers are identified by container name and communicate over a network which Denlin calls `proxy-network`.
>
> Containers can be identified by a tagged name using the `-t` flag, or the name assigned by Docker.

To create the Nginx proxy, use the following command:


```sh
denlin services

```

Then select the option `setup-nginx-proxy`.

Once the Nginx proxy has been set up, visit your IP address. You should get HTTP Error 503(Service Unavailable) status code message from Nginx.


![Nginx HTTP Error 503 Screen Shot][nginx-http-error-503-screenshot]


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Set Up Your First Container


Test your installation by creating a test container:

```sh
denlin services

```

Then select the option `new-hello-world-container`.

For this test, for the service name, you can use the name `hello-world`.


> [!TIP]
> ## Hello World Image
> The `Hello World` image used in this script will displays a simple "Hello, World!" message in the browser


Once done, use search to find your DNS records in your web domain hosting provider's control panel.

Add a new DNS record using the output from the script, example if using a subdomain:


| Type       | Name                           | Points to       | TTL   |
| ---------- | ------------------------------ | --------------- | ----- |
| A          | hello-world.monatemedia.com    | 77.243.85.71    | 14400 |

Also note that if the application will be hosted in the main domain, the `Name` value will be `@`. 

Now visit your domain or subdomain in the browser, and you should see your Hello World website over HTTPS.

> [!WARNING]
> ### If HTTP works but HTTPS doesn't load at all
> The certificate request fires the moment the container starts — which, following the steps in order, happens *before* the DNS record you're told to add even exists yet. That first attempt fails with a DNS lookup error, and the Let's Encrypt companion only retries once an hour on its own, not immediately. If HTTP works but HTTPS won't load, this is almost certainly why. Confirm it:
> ```sh
> docker logs letsencrypt-companion --tail 20
> ```
> Look for something like `NXDOMAIN` or `DNS problem`. If you see that, DNS has since propagated (that's why HTTP already works) — you just need to force a retry rather than wait out the hour. Simply restarting your app's container **won't** do it; the companion only re-checks when a container's configuration changes, not on every restart. Restart the companion itself instead, which re-processes everything on boot:
> ```sh
> docker restart letsencrypt-companion
> ```
> Give it 20-30 seconds, then check the log again for `Your cert is in: ...` — HTTPS should work immediately after.


![Hello World Screen Shot][hello-world-screenshot]

### Clean Up the Test Container

This container was only ever meant to prove Docker, Nginx, and SSL actually work together — once you've confirmed HTTPS loads, remove it rather than leaving a "Hello World" page live on a real subdomain indefinitely.

On the VPS:

```sh
cd ~/hello-world
docker compose down
cd ~
rm -rf ~/hello-world
```

Then remove the DNS record you added for it. In your domain provider's DNS zone editor (or DNS Records panel), find the `A` record with `Name`/`Host` matching what you used for this test (e.g. `hello-world`) pointing at your VPS IP, and delete just that one — leave any records for your real domain or subdomains untouched.

> [!TIP]
> If your host has an AI assistant like Kodee (see the "Managing a Domain, Email, and VPS Across Different Companies" section near the top), it's a fast way to do this — just tell it exactly which record to remove and have it confirm before applying. If not, the manual steps above work the same everywhere; DNS panels vary in layout but all have some form of a records list you can search or filter by name.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Install the GitHub CLI (`gh`)

Now it's time to do some configuration on our local development computer. Make sure you are navigated to the folder where you store your projects on your local computer.

### 1. Check if GitHub CLI is Installed

On your local computer, check if you have the GitHub CLI installed.

```sh
gh --version
```

You should receive an output like this:

```sh
gh version 2.65.0 (2025-01-06)
https://github.com/cli/cli/releases/tag/v2.65.0
```

### 2. Install GitHub CLI on Local Computer

If the GitHub CLI isn't already installed on your local computer, you can install it by following the [official instructions](https://cli.github.com/). You may also install it using the command line.


#### Windows Install

On Windows, you can it install with:

```sh
winget install --id GitHub.cli

```

> [!IMPORTANT]
> The Windows installer modifies your PATH. When using Windows Terminal, you will need to open a new window for the changes to take effect. (Simply opening a new tab will not be sufficient.)

#### Mac Install

On Mac, you can install with Homebrew:

```sh
brew install gh

```

### 3. Test GitHub CLI Installation

Test the installation again.

```sh
gh --version
```

You should receive an output like this:

```sh
gh version 2.65.0 (2025-01-06)
https://github.com/cli/cli/releases/tag/v2.65.0
```

If you you get an error, close the terminal window and try again with a new terminal window.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Publish Your First Project

Create a new project on your local computer.  Make sure you are navigated to the folder where you store your projects, right-click in the folder and open a GitBash terminal in this folder. From here the process will create the project folder for you.

Create a new React project with Vite.

```sh
npm create vite@latest

```

Complete the flow by selecting (y) to install packages, choose a `Project name`, `framework` and options like `variant`. Change into your directory, run `npm install` and `npm run dev`. 

```sh
Need to install the following packages:
create-vite@6.1.1
Ok to proceed? (y) y


> npx
> create-vite

√ Project name: ... react-counter
√ Select a framework: » React
√ Select a variant: » TypeScript

Scaffolding project in C:\Users\Lenovo\Coding Projects\react-counter...

Done. Now run:

  cd react-counter
  npm install
  npm run dev


Lenovo@DESKTOP MINGW64 ~/Coding Projects/
$ cd react-counter

Lenovo@DESKTOP MINGW64 ~/Coding Projects/react-counter
$ npm install

Lenovo@DESKTOP MINGW64 ~/Coding Projects/react-counter
$ code .

Lenovo@DESKTOP MINGW64 ~/Coding Projects/react-counter
$ npm run dev
```

You should now be able to visit your new app at `http://localhost:5173/`


![Vite React App Screen Shot][vite-react-app-screenshot]


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Create Dockerfile


To create a Dockerfile, use `create-dockerfile` command in Denlin's Services Menu.


> [!IMPORTANT]
> 
> ### What is a Dockerfile?
> 
> A Dockerfile is a template for an image of our application. The image is then a template for a Docker container, which is a runnable instance of the Docker image, and uses a `docker-compose.yaml` file to run the image. 
> 
> We will run multiple Docker containers to host our applications.


Call the Services Menu

```sh
denlin services

```

From services menu select `create-dockerfile`.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Build & Run the Container in Docker Desktop

> [!IMPORTANT]
> 
> ### Docker Containers in Local Environment
>
> To build and run containers in your local development environment, make sure that you have Docker Desktop running.

### 1. Build the Docker Image

Run the following command in your project root (where your Dockerfile is located):

```sh
docker build -t react-counter .

```

This will:

  - Use ***Node.js*** to install dependencies and build the app.
  - Copy the dist/ folder to an ***NGINX*** container.

### 2. Run the Container

Run the following command to start your container:

```sh
docker run -d -p 8080:80 --name react-counter-container react-counter

```

This will:

  - Run the container in ***detached mode*** (`-d`).
  - Map port ***8080*** on your machine to port ***80*** inside the container.
  - Name the container ***react-counter-container***.

### 3. Access the App

After running the container, open your browser and visit:
http://localhost:8080

You may also access your container through Docker Desktop.


> [!CAUTION]
> 
> ### Successful Docker Builds
>
> When debugging your container, you must be sure that the container runs on Docker Desktop without any issues before attempting further deployment. 
>
> If the application does not run on Docker Desktop, the application will not run in deployment.


### 4. Stop & Remove the Container (If Needed)

To stop the running container:

```sh
docker stop react-counter-container

```

To remove it completely:

```sh
docker rm react-counter-container

```

### 5. (Optional) View Logs & Debug

Check running containers:

```sh
docker ps

```

Check logs of your container:

```sh
docker logs react-counter-container

```


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Create a GitHub Personal Access Token (PAT)

To create a GitHub PAT, use `create-github-pat` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `create-github-pat`

The `create-github-pat` will automatically log your VPS and local computer into the GitHub Registry using the PAT.


> [!TIP]
> To access the GitHub Container Registry we first need to create a PAT.
>
> 
> To create a new token visit: [GitHub Create New Personal Access Token](https://github.com/settings/tokens/new).
>
> 
> You can also get there in GitHub by clicking on your profile -> Settings -> Developer Settings -> Personal access tokens -> Tokens(classic) -> Generate new token


To generate a **new personal access token (classic)** for a server named `VPS 1` with `write:packages`, `delete:packages`, `read:org` and `admin:public_key` scopes, enter the name in the `Note` input box, select the corresponding boxes, then select `Generate token`

Note: **VPS 1**

Select 90 days till expiry

Scope:
- [x] `write:packages`
- [x] `delete:packages`
- [ ] `admin:org`
  - [ ] `write:org`
  - [x] `read:org`
  - [ ] `manage_runners:org`
- [x] `admin:public_key`

Copy and keep your token in a safe place. Do not share your token with anyone or commit it to version control systems like GitHub or the GitHub Container Registry.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Log into GitHub with the GitHub CLI

To use the `gh` CLI, you need to authenticate the user on your local machine.

Open a GitBash terminal in your projects folder and log into GitHub CLI.

```bash
gh auth login

```

Follow the interactive prompts to log into your GitHub account, using your `PAT` when asked for your `authentication token`.

```MarkDown
What account do you want to log into? GitHub.com
What is your preferred protocol for Git operations? SSH
------
Generate a new SSH key to add to your GitHub account? (Y/n) Y
--or--
? Upload your SSH public key to your GitHub account?  [Use arrows to move, type to filter]
> C:\Users\Lenovo\.ssh\id_rsa.pub
  Skip
(If the key already exists, use that one)
------
Enter a passphrase for your new SSH key (Optional)
Title for your SSH key: (GitHub CLI)
How would you like to authenticate GitHub CLI? Paste an authentication token
Paste your authentication token: `****` 
```

> [!TIP]
> 
> You will find the PAT saved in the `.env` file in the root of your project as the variable `CR_PAT` from using the `create-github-pat` function in the previous step.

If your GitHub authorization fails, please try again. 

```sh
gh auth logout
gh auth login

```

GitHub CLI may ask you to authenticate your device with the browser, by giving you a one-time code and asking you to log into GitHub with `https://github.com/login/device`

```sh
Lenovo@DESKTOP-UQBI21I MINGW64 ~/OneDrive/Coding Projects/react-counter
$ gh auth login

! First copy your one-time code: E90B-9AAA
Open this URL to continue in your web browser: https://github.com/login/device
✓ Authentication complete.
✓ Logged in as monatemedia
```


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Initialize GitHub Repository

To initialize your GitHub repository, use `initialize-git-repository` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `initialize-git-repository`.

> [!WARNING]
>
> ### Ensure Project is On `Main` Branch
> 
> These scripts assume that your project is on the `main` branch of your repository. 
> 
> If your project is on `master`, please go into the settings of your repo and change the main branch from `master` to `main`. 


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Store PAT as a GitHub Actions Secret

We want to store our GitHub Personal Access Token (PAT) in the GitHub Actions Secrets so that GitHub is able to log into our GitHub Registry and save our image into the registry.

To store your PAT as a GitHub secret, use `create-github-actions-secret-pat` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `create-github-actions-secret-pat`. 

This script stores your PAT in your project's Repository secrets.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Store Docker Image to GitHub Container Registry

To create and store your Docker image to the GitHub Container Registry, use `store-docker-image` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `store-docker-image`.


> [!IMPORTANT]
> Docker Desktop should be running on your local machine to store your Docker image to the GitHub registry. The process cannot succeed without it.


## Create A Docker Compose File

Now, we want to host our container on our server. For that we will use `docker-compose`. 

`docker-compose` is basically a `yml` file where we specify the properties of our container, and that way we can just run the `docker-compose` file, and not have to use a `docker run` command, making it much easier to run containers.

To create and store your Docker image to the GitHub Registry, use `create-docker-compose` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `create-docker-compose`.



_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Create A GitHub Actions CI/CD Pipeline

Always running docker build and docker push to bring our new image to our server is annoying, so we will create a GitHub Action to automate this process.

The action will run every time you push changes to the main branch of your repository, and triggers the commands we want to run. We will run commands that will bring the image to the VPS server.

So every time we push our code changes to the main branch of our repository, we also want to pull the changes into our server, and then restart the container.

### 1. Create SSH Key Pair For The Server

GitHub Actions needs to SSH into your VPS to deploy your application. To do this securely, we use an SSH key pair — a private key and a public key that are mathematically linked.

- The **private key** is given to GitHub Actions as a secret. It never touches your server.
- The **public key** is added to your VPS. It tells the server "trust whoever holds the matching private key."

This means GitHub Actions can prove its identity to your server without ever using a password.

#### Key Type: ed25519

We use the `ed25519` algorithm instead of the older `RSA` algorithm. ed25519 is the current standard for SSH keys because it uses a more complex elliptic curve algorithm that is as secure as a 4096-bit RSA key, but produces a much shorter key. It is supported by all modern software.

#### Key Naming Convention

Name your key after the server it is used to access, and include the year it was created. This makes it easy to identify keys and know when to rotate them. You should rotate your SSH keys every 1-2 years.

Example: `kvm1_2026` (server name: kvm1, year created: 2026)

Include a descriptive comment in the key itself using the format `servername+year@yourdomain.com`. This comment is visible when you share the public key, and signals to others that you follow security best practices.

#### Generate the Key

Run this command on your **local machine** (not the server). Generating the key locally means the private key never has to travel over a network connection.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/kvm1_2026 -C "kvm1+2026@monatemedia.com"
```

You will be prompted for a passphrase. Always set a passphrase — it encrypts the private key file so that even if your machine is stolen, the key cannot be used without it.

This creates two files:
- `~/.ssh/kvm1_2026` — your private key (never share this with anyone)
- `~/.ssh/kvm1_2026.pub` — your public key (this gets added to servers)

#### Add the Public Key to Your VPS

Copy the public key to your server so it knows to trust connections made with this key:

```bash
ssh-copy-id -i ~/.ssh/kvm1_2026.pub edward@your-server-ip
```

This appends your public key to `~/.ssh/authorized_keys` on the server automatically.

#### Verify the Key Works

Test that you can log in using the key before giving it to GitHub Actions:

```bash
ssh -i ~/.ssh/kvm1_2026 edward@your-server-ip
```

You should be prompted for your key passphrase (not your server password) and then logged in successfully.

#### Copy the Private Key for GitHub Actions

Display the private key so you can copy it to your clipboard:

```bash
cat ~/.ssh/kvm1_2026
```

Copy the entire output including the `-----BEGIN OPENSSH PRIVATE KEY-----` and `-----END OPENSSH PRIVATE KEY-----` lines.

> **Caution: Safeguard SSH Keys**
> Never share your private key with anyone. If a private key is ever compromised, remove the corresponding public key from `~/.ssh/authorized_keys` on every server it was used on, and generate a new key pair.

### 2. Create GitHub Repository Secrets

Go to your project's folder in GitHub and select the **Settings** tab.

In the sidebar on the left, open **Secrets and variables**, and select **Actions**.

Inside the GitHub Actions secrets and variables section, select **New repository secret**.

Add secrets as Name/Value pairs for:

- `PRODUCTION_SSH_KEY` — the private key content copied in the previous step
- `PRODUCTION_USER` — the username you log into the VPS with (e.g. `edward`)
- `PRODUCTION_HOST` — the IP address of your server
- `PRODUCTION_WORK_DIR` — absolute path to the directory containing your `docker-compose.yml` (e.g. `/home/edward/actuallyfind`)

### 3. Push Changes to Repository

Inside your project folder on your local computer, push your changes to the repository.

Add your changes to the git staging area:

```bash
git add .
```

Commit your changes:

```bash
git commit -m "feat: deploy"
```

Push your changes to the repository:

```bash
git push
```

### 4. Confirm Workflow Execution

Go to your project's folder in GitHub and select the **Actions** tab.

You should see a new workflow running where the workflow triggers a publish image and deploy image workflow.

> **Tip: Connection closed by remote host Error**
>
> If in the deploy image step you have an error `Connection closed by remote host`, restart your server:
> ```bash
> sudo reboot
> ```
> You should be able to log back into the server normally in a short while. Then rerun the failed job again.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Deploying Multiple Environments (Staging & Production)

> [!NOTE]
> Everything in "Create A GitHub Actions CI/CD Pipeline" above assumes one VPS, one
> environment, one secret group (`PRODUCTION_SSH_KEY`, `PRODUCTION_USER`, `PRODUCTION_HOST`,
> `PRODUCTION_WORK_DIR`). A project that instead runs separate `deploy-staging` and
> `deploy-production` jobs needs a fully-prefixed secret group *per environment* —
> `STAGING_SSH_HOST`/`PRODUCTION_SSH_HOST`, `STAGING_SSH_USER`/`PRODUCTION_SSH_USER`, and so
> on — which is what `create-deploy-ssh` (below) generates. Note this is a different naming
> shape than section 2 above (`PRODUCTION_USER`/`PRODUCTION_HOST`, no `_SSH_` in the middle) —
> if a future project's generated workflow (see `services/github-actions/docker-publish.yml`)
> is extended to multiple environments, standardizing its secret names on the `{ENV}_SSH_*`
> shape avoids a manual rename step every time.

> [!WARNING]
> ### The `PAT` Secret Doesn't Follow You Between Repos
> Before any of the steps below, make sure this repository can actually log into the GitHub
> Container Registry. The generated workflow's `publish` job runs `docker login ghcr.io` using
> *this repo's own* `PAT` secret before it can push an image — if that secret is missing or
> stale here, the run fails with `denied: denied` in the Actions log, which looks like a deploy
> problem but isn't one. Having already set this up for a different project doesn't carry over:
> the underlying token (`CR_PAT`, saved once in `/etc/denlin-cli.conf` on the VPS by
> `create-github-pat`) can safely be reused across projects sharing that VPS, but the `PAT`
> GitHub Actions secret itself is per-repository and has to be pushed to *this* repo
> separately, even if it's the exact same token value. If you haven't already run these for
> this project, do so now, in this order:
> 1. `create-github-pat` (see "Create a GitHub Personal Access Token (PAT)" above) — reuses
>    your saved `CR_PAT` instead of generating a new one if it's still valid.
> 2. `create-github-actions-secret-pat` (see "Store PAT as a GitHub Actions Secret" above) —
>    pushes it as this repo's `PAT` secret.

### Scaffold the Local Deploy Files

Before generating a deploy key, get the local files that hold your app's environment
configuration in place. Use `configure-deploy-env` in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `configure-deploy-env`.

This never touches the VPS beyond downloading itself and cleaning up afterwards — it only
creates files in your project's own local repo:

- `.gitignore` — created if missing, and `.env.deploy-base` / `.env.deploy-secrets.production`
  / `.env.deploy-secrets.staging` are added to it if they aren't already listed.
- `.env.deploy-base` — values that are identical between staging and production. Created
  once, shared by both environments.
- `.env.deploy-secrets.<environment>` — values that differ between staging and production,
  for the one environment you selected.

Neither file gets pre-filled with guessed field names — Denlin has no way to know what a
particular app actually needs, so both are created as blank templates with an explanatory
comment, and you fill them in yourself based on what your `docker-compose.yml` expects. Run
it once per environment (`staging`, then `production`); an already-existing file is always
left alone, never overwritten.

> [!NOTE]
> ### Why two files instead of one
> The real distinction isn't "secret vs. non-secret" — a shared value can still be a real
> credential. It's "shared vs. environment-specific": if a value is identical in staging and
> production, it belongs in `.env.deploy-base`; if it differs at all, it belongs in the
> matching `.env.deploy-secrets.<environment>` file, even if that particular value isn't
> secret either. `provision-app-env` (below) merges the two, with the environment-specific
> file always winning on a conflicting key.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Generate a Deploy Key Per Environment

To generate an SSH deploy key for a specific environment, install it on the VPS, and upload
it as GitHub Actions secrets, use `create-deploy-ssh` in Denlin's Services Menu.

Call the Services Menu

```sh
denlin services

```

From services menu select `create-deploy-ssh`.

> [!WARNING]
> ### This Key Must Have No Passphrase
>
> Unlike your own personal login key (`denlin setup-ssh-login`, which correctly *does* prompt
> for a passphrase), this key is loaded unattended by GitHub Actions' `ssh-agent` step. There's
> no human in that pipeline to answer a passphrase prompt, so a passphrase-protected key fails
> in CI the same way it fails a local `ssh -o BatchMode=yes` check — `Permission denied
> (publickey)`, even when the public key is correctly installed on the VPS. `create-deploy-ssh`
> generates the key with `-N ""` for you, so there's nothing to answer.

You'll be asked which environment this key is for (`staging` or `production`) and the absolute
work directory on the VPS for that environment. If staging and production share one VPS, give
each a distinct work directory — the deploy job's own cleanup step (`rm -f
${WORK_DIR}/docker-compose.yml`) will otherwise let one environment's deploy delete the other's
compose file.

The script runs the same `ssh-keyscan` check the "Add Server to Known Hosts" CI step runs
before it ever touches GitHub, so a wrong IP, closed firewall port, or downed VPS shows up
locally in seconds instead of after a multi-minute CI run — then uploads
`{ENV}_SSH_HOST`/`{ENV}_SSH_USER`/`{ENV}_SSH_KEY`/`{ENV}_WORK_DIR` for you. For `production`,
it uploads as an Environment secret (`gh secret set ... --env production`) rather than a plain
repository secret, since a job declaring `environment: "production"` is the one place required
reviewers / branch protection rules could later apply.

Repeat for each environment (`staging`, then `production`).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Merge and Send the .env to the VPS

Once `.env.deploy-base` and `.env.deploy-secrets.<environment>` are filled in, use
`provision-app-env` in Denlin's Services Menu to build the real `.env` and send it to the
VPS.

Call the Services Menu

```sh
denlin services

```

From services menu select `provision-app-env`.

This merges the two local files — the environment-specific file wins on any key both
define — and `scp`s the result to the VPS as `.env` in the work directory `create-deploy-ssh`
set up for that environment. Like `configure-deploy-env`, app-runtime values never touch
GitHub Actions secrets at all — only the four SSH values above do.

> [!WARNING]
> ### An existing `.env` is never silently overwritten
> If `.env` already exists at the target work directory — the normal case any time you're
> rotating a credential rather than provisioning for the first time — the script asks before
> replacing it, and backs the old one up first as `.env.bak-<timestamp>` (timestamped using
> the VPS's own clock, not your local machine's). Answering no cancels without sending
> anything.

Provisioning the `.env` doesn't restart anything on its own. Trigger a deploy afterwards
(push a tag, or run the workflow manually) for the change to actually take effect —
`docker-publish.yml`'s deploy jobs only verify `.env` exists, they don't read or write it.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- Create Start Script -->
## Usage

This setup uses Docker's networking feature to communicate with containers and Nginx's reverse proxy feature to protect containers from the public facing internet.

When creating and publishing new Docker containers with `.yml` files, be sure to include the following information in your `docker-compose.yml` file to ensure that Nginx can commmunicate with your container:

```yml
# Template: Hello World
# Description: A test container that displays a simple "Hello, World!" message in the browser.

services:
  hello-world: # Use the service name as the container name
    container_name: hello-world # Use the service name as the container name
    image: crccheck/hello-world
    environment:
      VIRTUAL_HOST: hello-world.monatemedia.com # Tell nginx-proxy to route traffic based on the service name eg. hello-world.monatemedia.com
      LETSENCRYPT_HOST: hello-world.monatemedia.com # Enable Let's Encrypt SSL for this domain
      VIRTUAL_PORT: 8000 # Tell nginx-proxy that the container serves on port 8000
    networks:
      - proxy-network

networks:
  proxy-network:
    external: true
```

Do not forget to create a DNS record for your container to be reached at the desired website address, as provided in the `VIRTUAL_HOST` for unsecured HTTP on port 80, and `LETSENCRYPT_HOST` for secured HTTPS on port 443. All three should be the same.

_For more examples, please refer to the [Documentation](https://github.com/monatemedia/docker-engine-on-linux/wiki)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

- [ ] Node `docker-compose.yml` script
- [ ] PHP Laravel `docker-compose.yml` script
- [ ] Python Scripts
    - [ ] Django `docker-compose.yml` script
    - [ ] Streamlit `docker-compose.yml` script

See the [open issues](https://github.com/monatemedia/docker-engine-on-linux/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Top contributors:

<a href="https://github.com/monatemedia/docker-engine-on-linux/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=monatemedia/docker-engine-on-linux" alt="contrib.rocks image" />
</a>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Monate Media - [@MonateMedia](https://twitter.com/MonateMedia) - edward@monatemedia.com 

Project Link: [https://github.com/monatemedia/docker-engine-on-linux](https://github.com/monatemedia/docker-engine-on-linux)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

- [Othneil Drew Starter README Template](https://github.com/othneildrew/Best-README-Template/)
- [Ileriayo Adebiyi Markdown Badges](https://github.com/Ileriayo/markdown-badges)
- [Programonaut How To Easily Set Up A Server (VPS) For Your Side Projects](https://youtu.be/v1SvBm5Wn8I?si=KraIJZwkuOiRfBnx)
- [Programonaut How To Host An Application On A Server (VPS) Using Docker?](https://youtu.be/zHh7oGjkefY?si=vw2BcVUtFLtxxbV3)
- [Programonaut How To Set Up A Domain For Your Application!](https://youtu.be/MUYmFtxykMA?si=UyQyrgHJcU4yN-5O)
- [Programonaut How To Set Up A Reverse Proxy With Free SSL Using Nginx-Proxy](https://youtu.be/ynGeCodXFXI?si=SiLZG3MJK3SHEttI)
- [Django Road Deploying Django with Docker Compose, Gunicorn and Nginx](https://youtu.be/vJAfq6Ku4cI?si=uPeJRauxcgIClGUX)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/monatemedia/docker-engine-on-linux.svg?style=for-the-badge
[contributors-url]: https://github.com/monatemedia/docker-engine-on-linux/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/monatemedia/docker-engine-on-linux.svg?style=for-the-badge
[forks-url]: https://github.com/monatemedia/docker-engine-on-linux/network/members
[stars-shield]: https://img.shields.io/github/stars/monatemedia/docker-engine-on-linux.svg?style=for-the-badge
[stars-url]: https://github.com/monatemedia/docker-engine-on-linux/stargazers
[issues-shield]: https://img.shields.io/github/issues/monatemedia/docker-engine-on-linux.svg?style=for-the-badge
[issues-url]: https://github.com/monatemedia/docker-engine-on-linux/issues
[license-shield]: https://img.shields.io/github/license/monatemedia/docker-engine-on-linux.svg?style=for-the-badge
[license-url]: https://github.com/monatemedia/docker-engine-on-linux/blob/main/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/company/monatemediaofficial
[product-screenshot]: images/denlin-main-menu-large.PNG
[nginx-http-error-503-screenshot]: images/nginx-http-error-503-screenshot.png
[hello-world-screenshot]: images/hello-world.png
[vite-react-app-screenshot]: images/vite-react-app.png
[Ubuntu.com]: https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white
[Ubuntu-url]: https://ubuntu.com/
[Docker-hub]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-hub-url]: https://hub.docker.com/
[Github]: https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white
[Github-url]: https://github.com/monatemedia/docker-engine-on-linux
[Github Actions]: https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white
[Github-actions-url]: https://github.com/features/actions
[Nginx]: https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white
[Nginx-url]: https://nginx.org/en/
[Gunicorn]: https://img.shields.io/badge/gunicorn-%298729.svg?style=for-the-badge&logo=gunicorn&logoColor=white
[Gunicorn-url]: https://gunicorn.org/
[Lets-Encrypt]: https://avatars.githubusercontent.com/u/9289019?s=75&v=4
[Lets-Encrypt-url]: https://letsencrypt.org/
[Htop.dev]: https://avatars.githubusercontent.com/u/69567116?s=48&v=4
[Htop-url]: https://htop.dev/
[Angular.dev]: https://img.shields.io/badge/angular-%23DD0031.svg?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.dev/
[Next.org]: https://img.shields.io/badge/Next-black?style=for-the-badge&logo=next.js&logoColor=white
[Next-url]: https://nextjs.org/
[Nuxt.net]: https://img.shields.io/badge/Nuxt-002E3B?style=for-the-badge&logo=nuxtdotjs&logoColor=#00DC82
[Nuxt-url]: https://nuxt.com/
[Svelte.dev]: https://img.shields.io/badge/svelte-%23f1413d.svg?style=for-the-badge&logo=svelte&logoColor=white
[Svelte-url]: https://svelte.dev/
[HTML5]: https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white
[HTML5-url]: https://html.spec.whatwg.org/
[CSS3]: https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white
[CSS3-url]: https://www.w3.org/TR/CSS/#css
[JavaScript]: https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E
[JavaScript-url]: https://ecma-international.org/publications-and-standards/standards/ecma-262/
[Python.org]: https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[Python-url]: https://www.python.org/
[Djangoproject.com]: https://img.shields.io/badge/django-%23092E20.svg?style=for-the-badge&logo=django&logoColor=white
[Django-url]: https://www.djangoproject.com/
[FastAPI.dev]: https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi
[FastAPI-url]: https://fastapi.tiangolo.com/
[Flask.dev]: https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white
[Flask-url]: https://flask.palletsprojects.com/
[Streamlit.net]: https://img.shields.io/badge/Streamlit-%23FE4B4B.svg?style=for-the-badge&logo=streamlit&logoColor=white
[Streamlit-url]: https://streamlit.io/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[MySQL.com]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[MySQL-url]: https://www.mysql.com/
[Postgres.com]: https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white
[Postgres-url]: https://www.postgresql.org/
[MongoDB.com]: https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white 
[MongoDB-url]: https://www.mongodb.com/
[MariaDB.org]: https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white
[MariaDB-url]: https://mariadb.org/
[Redis.io]: https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white
[Redis-url]: https://redis.io/
[SQLite.org]: https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white
[SQLite-url]: https://www.sqlite.org/
[Php.net]: https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white
[Php-url]: https://www.php.net/
[WordPress.net]: https://img.shields.io/badge/WordPress-%23117AC9.svg?style=for-the-badge&logo=WordPress&logoColor=white
[WordPress-url]: https://wordpress.org/
[Vuejs.org]: https://img.shields.io/badge/vuejs-%2335495e.svg?style=for-the-badge&logo=vuedotjs&logoColor=%234FC08D
[vue-url]: https://vuejs.org/
[React.dev]: https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB
[React-url]: https://react.dev/