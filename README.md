# custom-builds

Custom image builds for some open source projects.
For example, it can be used for rebuilding an image with a current golang runtime or a new base image.
Other kind of simple patching are also possible.

## Usage

First you may change the `REGISTRY` variable in `common.mk` to define the registry used to push your custom images.

Then adjust or add custom builds in `*.make` files.

To run all changed or new custom builds just run

```bash
make all
```

It will only build images whose `.make` file is newer than its marker file `markers/*.done`.

## Development

To develop a custom build, create another `.make` file containing how to download the sources, building the container image
and how to push it to your registry.
Building the container image is performed using docker in docker typically.
You must also create a corresponding marker file in the subdirectory `markers`.
For example for a custom build named `my-custom-build.v1.2.3.make` run these touch commands

```bash
# create an empty marker file
touch markers/my-custom-build.v1.2.3.done
# ensure that make file has newer timestamp
touch my-custom-build.v1.2.3.make
```

It is expected to have a target `all` to perform all necessary steps.

To test a target for correct execution, run

```bash
make -f my-custom-build.v1.2.3.make <target>
```

Here target can be `all` or any target defined in this makefile.
