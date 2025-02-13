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
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
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


Self hosting done right can reduce the cost of hosting, but introduces additionaly complexity which will cost you taking longer to launch. 

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

Tested on Ubuntu 22.04

[![Ububtu][Ubuntu.com]][Ubuntu-url]


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

<!-- LOG INTO VPS -->
## Choose A VPS

I have chosen Hostinger


## VPS Settings

In your hosting provider's control panel, you'll want to chose an operating system for your VPS.

-  Choose a location closest to your customers
-  Choose Plain OS, not an OS with a control panel
-  Choose Ubuntu for your operating system
-  Choose a VPS hostname(optional)
-  Set a secure root password of at least 12 characters
-  We can skip creating an SSH Key as we will create that later(if provided)


## Log Into VPS

-  In your hosting services control panel, find your IP address for your VPS
-  On your local machine go to your terminal client. 
 

> [!TIP]
> ## Git Bash
> Git Bash is an application which provides an emulation layer for a Git command line experience. Windows users should use the Git Bash terminal client.
> Mac users can use their native command line shells, provided they have Git installed.


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


## Install Git

### 1. Update Your Package Index

Before installing Git, ensure your system is up-to-date:


```sh
sudo apt update && sudo apt upgrade
```


### 2. Install Git


```sh
sudo apt-get install git
```


### 3. Verify Installation

Once installed, verify the version of Git to ensure it’s installed correctly:


```sh
git --version
```


You should see an output like:


```sh
git version 2.x.x
```


## Create New User With Denlin CLI

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


## Set Up Passwordless SSH Login

Whenever logging into your VPS from your local computer, you will always be asked for your username `ssh edward@your_ip_address` and your password. This is fine but can be annoying if you have already secured your personal computer with a strong password.

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


Run this commad and follow the prompts


```sh
denlin setup-ssh-login
```


## Install Docker Engine

To install Docker Engine, use the following command:


```sh
denlin docker-install
```


## Set Up Nginx Proxy

To create the Nginx proxy, use the following command:


```sh
denlin common
```

Then select the option `setup-nginx-proxy`.


## Set Up Our First Container


Test your installation by creating a test container with these commands:

```sh
denlin common
```

Then select the option `new-test-container`.


## Create Your Project

If you have not as yet created your project, you can create a new project on your local computer by opening a terminal in the file folder where you intend to create the application's file folder. 

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

## Create Dockerfile

To create a Dockerfile, use `create-dockerfile` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `create-dockerfile`

> [!IMPORTANT]
> 
> ## What is a Dockerfile?
> 
> A Dockerfile is a template for an image of our application. The image is then a template for a Docker container, which is a runnable instance of the Docker image, and uses a `docker-compose.yaml` file to run the image. We will run multiple Docker containers to host our application.



## Create a GitHub Personal Access Token (PAT)

To create a GitHub PAT, use `create-github-pat` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `create-github-pat`

> [!NOTE]
> 
> ## Github Registry Login
>
> The `create-github-pat` will automatically log your VPS and local computer into the GitHub Registry using the PAT.


> [!TIP]
> To create a new token visit: [GitHub Create New Personal Access Token](https://github.com/settings/tokens/new) 


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

## Install the GitHub CLI (`gh`)

### 1. Installation

On your local computer, check if you have the GitHub CLI installed.

```sh
gh --version
```

You should recieve an output like this:

```sh
gh version 2.65.0 (2025-01-06)
https://github.com/cli/cli/releases/tag/v2.65.0
```

If the GitHub CLI isn't already installed on your local computer, you can install it by following the [official instructions](https://cli.github.com/). You may also install it using the command line.
 
On Windows, you can it install with:

```sh
winget install --id GitHub.cli
```

> [!IMPORTANT]
> The Windows installer modifies your PATH. When using Windows Terminal, you will need to open a new window for the changes to take effect. (Simply opening a new tab will not be sufficient.)

On Mac, you can install with Homebrew:

```sh
brew install gh
```

### 2. Test Installation

```sh
gh --version
```

You should recieve an output like this:

```sh
gh version 2.65.0 (2025-01-06)
https://github.com/cli/cli/releases/tag/v2.65.0
```

If you you get an error, close the terminal window and try again with a new terminal window.

   
### 3. Authentication

To use the `gh` CLI, you need to authenticate the user on your local machine.

```bash
gh auth login
```

Follow the interactive prompts to log in using your GitHub account.

```MarkDown
What account do you want to log into? GitHub.com
What is your preferred protocol for Git operations? SSH
Generate a new SSH key to add to your GitHub account? (Y/n) Y
(If the key already exists, use that one)
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

## Initialize GitHub Repository

To initialize your GitHub repository, use `initialize-git-repository` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `initialize-git-repository`.


## Create and Store Docker Image to GitHub Registry

To create and store your Docker image to the GitHub Registry, use `store-docker-image` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `store-docker-image`.


> [!IMPORTANT]
> Docker Desktop should be running on your local machine to store your Docker image to the GitHub registry. The process cannot succeed without it.


## Create GitHub Secret

We want to store our GitHub Personal Access Token (PAT) in the GitHub Action Secrets so that GitHub Actions is able to log into our GitHub Registry and pull our image from there.

To store your PAT as a GitHub secret, use `create-github-actions-secret` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `create-github-actions-secret`.


## Create A GitHub Action

Always running `docker build` and `docker push` to bring our new image to our server is annoying, so we will create a GitHub Action to automate this process.

The action will run every time you push changes to the main branch of your repository, and then it will triggers the commands we want to run.

To create a GitHub Action, use `create-github-action` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `create-github-action`.

## Create A Docker Compose File

Now, we want to host our container on our server. For that we will use `docker-compose`. 

`docker-compose` is basically a `yml` file where we specify the properties of our container, and that way we can just run the `docker-compose` file, and not have to use a `docker run` command, making it much easier to run containers.

To create and store your Docker image to the GitHub Registry, use `create-docker-compose` command in Denlin's Services Menu.

Call the Services Menu

```sh
denlin common
```

From services menu select `create-docker-compose`.

<!-- CREATE SHARED PROXY -->
## Create Shared Proxy

You can use a single, centralized nginx-proxy container to manage your applications. This container will act as a reverse proxy and route traffic based on the subdomain to the correct application.

### Create Docker Compose

From the root directory of your VPS create a folder called shared proxy.

```sh
mkdir shared-proxy
```

Enter the directory

```sh
cd shared-proxy
```

Make a file called `docker-compose.yml`

```sh
touch docker-compose.yml
```

Enter file with VIM or NANO and enter contents.

  ```sh
  vi docker.compose.yml
  ```

Enter contents

  ```sh
  services:
    nginx-proxy:
      container_name: nginx-proxy
      image: nginxproxy/nginx-proxy
      restart: unless-stopped
      ports:
        - "80:80"
        - "443:443"
      volumes:
        - /var/run/docker.sock:/tmp/docker.sock:ro
        - ./nginx/html:/usr/share/nginx/html
        - ./nginx/certs:/etc/nginx/certs
        - ./nginx/vhost:/etc/nginx/vhost.d
        - ./nginx/acme:/etc/acme.sh
      networks:
        - proxy-network

    letsencrypt-companion:
      container_name: letsencrypt-companion
      image: jrcs/letsencrypt-nginx-proxy-companion
      restart: unless-stopped
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock:z
        - ./nginx/acme:/etc/acme.sh:rw
      networks:
        - proxy-network
      environment:
        DEFAULT_EMAIL: <yourEmail>

  networks:
    proxy-network:
      external: true
  ```


### Create Proxy Network

Create the proxy-network Docker network by running this bash command (only once):

  ```sh
  docker network create proxy-network
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- VITE SVELTE DOCKER PROJECT -->
## Create Vite Svelte Docker Compose

This is an example of how you may set up your vite project locally. Here we are setting up this app: https://github.com/monatemedia/svelte-counter

### Create Docker Compose

From the root directory of your VPS create a folder called svelte-counter

```sh
mkdir svelte-counter
```

Enter the directory

```sh
cd svelte-counter
```

Make a file called `docker-compose.yml`

```sh
touch docker-compose.yml
```

Enter file with VIM or NANO and enter contents.

```sh
services:
  svelte-counter:
    container_name: svelte-counter
    image: ghcr.io/monatemedia/svelte-counter:latest
    environment:
      VIRTUAL_HOST: monatehub.monatemedia.com
      LETSENCRYPT_HOST: monatehub.monatemedia.com
    networks:
      - proxy-network

networks:
  proxy-network:
    external: true
```

Save and close the the file

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- PYTHON DJANGO DOCKER PROJECT -->
## Create Python Django Docker Project

This is an example of how you may set up your python django project locally. Here we are setting up this app: https://github.com/monatemedia/python-django-achievementhq

### Create Docker Compose

From the root directory of your VPS create a folder called python-django-achievementhq

```sh
mkdir python-django-achievementhq
```

Enter the directory

```sh
cd python-django-achievementhq
```

Make a file called `docker-compose.yml`

```sh
touch docker-compose.yml
```

Enter file with VIM or NANO and enter contents.

```sh
services:
  achievementhq_db:
    image: postgres:latest
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - proxy-network

  achievementhq_web:
    image: ghcr.io/monatemedia/python-django-achievementhq:latest
    restart: unless-stopped
    env_file:
      - .env
    environment:
      VIRTUAL_HOST: achievementhq.monatemedia.com
      LETSENCRYPT_HOST: achievementhq.monatemedia.com
    networks:
      - proxy-network

volumes:
  postgres_data:

networks:
  proxy-network:
    external: true
```

Save and close the file

### Start Centralized Proxy and Applications

Start the centralized `nginx-proxy` setup:

```sh
cd ~
cd shared-proxy
docker compose up
```

Start Each Application

```sh
cd /svelte-counter
docker compose up -d

cd /python-django-achievementhq
docker compose up -d
```

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Create Automation Scripts -->
## Create Automation Scripts

You can make management of your various application scripts easier by creating scripts.

### Create a Start Script

Navigate to your home directory

```sh
cd ~
```

Create a new shell script, `start-all.sh`

```sh
touch start-all.sh
```

Open the shell script

```sh
vi start-all.sh
```

Add the following lines to the start-all.sh file. Replace the paths with the actual paths to your docker-compose.yml files:

```sh
#!/bin/bash

echo "Starting centralized proxy..."
cd /shared-proxy
docker compose up -d

echo "Starting svelte-counter app..."
cd /svelte-counter
docker compose up -d

echo "Starting python-django-achievementhq app..."
cd /python-django-achievementhq
docker compose up -d

echo "All services started!"

```

Save and close the VIM editor

Make the script executable by running:

```sh
chmod +x start-all.sh

```

Run the script

```sh
start-all.sh

```

### Create a Stop Script

Navigate to your home directory

```sh
cd ~
```

Create a new shell script, `stop-all.sh`

```sh
touch stop-all.sh
```

Open the shell script

```sh
vi stop-all.sh
```

Add the following lines to the start-all.sh file. Replace the paths with the actual paths to your docker-compose.yml files:

```sh
#!/bin/bash

echo "Stopping python-django-achievementhq app..."
cd /python-django-achievementhq
docker compose down

echo "Stopping svelte-counter app..."
cd /svelte-counter
docker compose down

echo "Stopping centralized proxy..."
cd /shared-proxy
docker compose down

echo "All services stopped!"

```

Save and close the VIM editor

Make the script executable by running:

```sh
chmod +x stop-all.sh

```

Run the script

```sh
stop-all.sh

```

### Create a Reboot Script

Navigate to your home directory

```sh
cd ~
```

Create a new shell script, `reboot-all.sh`

```sh
touch reboot-all.sh
```

Open the shell script

```sh
vi reboot-all.sh
```

Add the following lines to the start-all.sh file. Replace the paths with the actual paths to your docker-compose.yml files:

```sh
#!/bin/bash

# Navigate to each project directory and restart the services
cd /path/to/svelte-counter
docker compose down && docker compose up -d

cd /path/to/python-django-achievementhq
docker compose down && docker compose up -d

# Add more directories as needed following the same pattern

echo "All services have been restarted successfully."

```

Save and close the VIM editor

Make the script executable by running:

```sh
chmod +x reboot-all.sh

```

Run the script

```sh
reboot-all.sh

```

### Optional: Run on Server Reboot

If you want this script to run automatically when the server reboots:

edit your crontab

```sh
crontab -e

```

Add the following line to run the script at startup:

```sh
@reboot reboot-all.sh

```

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Create Start Script -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- Create Start Script -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

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