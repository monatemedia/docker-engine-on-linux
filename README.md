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


<p align="right">(<a href="#readme-top">back to top</a>)</p>


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


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Create New User With Denlin-CLI

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


Run this commad and follow the prompts


```sh
denlin setup-ssh-login
```


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


![Hello World Screen Shot][hello-world-screenshot]


<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Install the GitHub CLI (`gh`)

Now it's time to do some configuration on our local development computer. Make sure you are navigated to the folder where you store your projects on your local computer.

### 1. Check if GitHub CLI is Installed

On your local computer, check if you have the GitHub CLI installed.

```sh
gh --version
```

You should recieve an output like this:

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

You should recieve an output like this:

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
> ### Successfull Docker Builds
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

Always running `docker build` and `docker push` to bring our new image to our server is annoying, so we will create a GitHub Action to automate this process.

The action will run every time you push changes to the main branch of your repository, and triggers the commands we want to run. We will run commands that will bring the image to the VPS server. 

So every time we push our code changes ot the main branch of our repository, we also want to pull the changes into our server, and then restart the container.


### 1. Create SSH Key Pair For The Server

We have to create an SSH key on our server, and give that key to GitHub as an input variable. 

On the server, use the keygen utility to generate a new key.

```sh
ssh-keygen -t rsa -b 4096
```

Copy the content of the private key.

```sh
more ~/.ssh/id_rsa
```

Copy the contents of the file to the clipboard.

> [!CAUTION]
> ### Safeguard SSH Keys
> You should never share your `SSH_PRIVATE_KEY` with anyone, otherwise they will be able to access the server.

In addition, we will also add the public key to the authorized keys of our server.

```sh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Now reboot the server to update the keys.

```sh
sudo reboot
```

### 2. Create GitHub Repository Secrets

Go to your project's folder in GitHub and select the `Settings` tab.

In the sidebar on the left, open `Secrets and variables`, and select `Actions`. 

Inside the GitHub Actions secrets and variables section, select `New repository secret`

Add secrets as `Name` `Value` pairs for:

  - SSH_PRIVATE_KEY = The private key's copy we just copied to the clipboard.
  - SSH_USER = The name of the user you log into the VPS server with.
  - SSH_HOST = IP address of your server.
  - WORK_DIR = Directory containing our docker-compose.yml file, using the absolute path `/home/edward/react-counter`.

### 3. Push Changes to Repository

Inside your project folder on your local computer, push your changes to the repository.

Add your changes to the git staging area.

```sh
git add .
```

Commit your changes.

```sh
git commit -m feat: deploy
```

Push your changes to the repository.

```sh
git push
```

### 4. Confirm Workflow Execution

Go to your project's folder in GitHub and select the `workflows` tab.

You should see a new workflow running where the workflow triggers a `publish image` and `deploy image` workflow.

> [!TIP]
> 
> ### `Connection closed by remote host` Error
> 
> If in the deploy image step you have an error `Connection closed by remote host` restart your server.
>
> ```sh
> sudo reboot
> ```
>
> You should be able to log back into the server normally in a short while. 
>
> Now rerun the failed job `deploy image` again.


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