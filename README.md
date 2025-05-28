# AnomaApps

This repository contains a few Anoma applications that can be run from an Elixir code base.
To run these applications you only need access to a running Anoma controller, or run one yourself, locally.

## 📋 Dependencies

These applications change often, and the infrastructure they use even more, so it's important to double check your versions if something is broken.

 - Install the latest Juvix compiler and make sure it is in your path.
   At the time of writing, the applications are tested with `0.6.10-be6f5f3`.

 - Have access to an Anoma controller.
   At the time of writing, the applications are tested with branch `m1dnight/anoma-app-testbranch`.
   There is a Docker service present in this repository to make life easier. Usage is optional. Instructions below.


## 🛠️ Compile the Juvix sources

The applications consist of Elixir code and Juvix code. You need to compile the Juvix code before running the applications, or after changing the application source code.

There is a convenience Makefile to compile all Juvix sources. Run `make all` to compile all files.

> [!CAUTION]
> The compilation of files will print errors for Juvix files that do not have a `main` function. You can safely ignore these errors. Example below.
> ```
> juvix compile anoma priv/juvix/Spacebucks/Signing.juvix -o priv/juvix/.compiled/Signing.nockma
> /core-check:1:1: error:
> no `main` function
> make: [priv/juvix/.compiled/Signing.nockma] Error 1 (ignored)
> ```

## 🐳 Using Docker

This repository holds a Docker compose file to start up a controller locally if you should wish to use it.
If you want to use it, you have to build it once.

> [!NOTE]
> This Docker image is gigantic, and is only supposed to be used for local development.
> Instructions to remove it are below.

### Build

```shell
cd docker
docker compose build
# go get a coffee
```

### Run

The following command will attach to the container and drop you into the Elixir shell of the system.

```shell
cd docker
docker compose up -d
docker compose attach controller
```

### Stop and Remove

```shell
docker compose down
docker rmi controller:latest
```

## 🖥️ Using local instance

As an alternative to Docker, you can run your local instance of the Anoma controller, too.
Read the instructions [here](https://github.com/anoma/anoma) to get started.

## 🏃 Running Examples

This repository contains multiple examples. You can run each of them separately.

Before you run the examples, make sure you have the necessary infrastructure deployed.

- [x] Anoma Controller (local or Docker)
- [x] Compiled all Juvix files


### Spacebucks

### Kudos

### Hello World