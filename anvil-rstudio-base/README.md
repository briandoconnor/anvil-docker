| Latest Image Release | Docker Image URL | Date Updated | Questions or Feedback |
| --- | --- | --- | --- |
| 0.0.3 | us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.3 | 05/08/2020 | Contact the [Interactive Analysis Team](mailto:workbench-interactive-analysis@broadinstitute.org) |

# Galaxy, RStudio, Terminal Combo Image

I'm hosting these on Dockerhub under [briandoconnor/anvil-rstudio-base](https://hub.docker.com/repository/docker/briandoconnor/anvil-rstudio-base).

The commands below assume 1.9 is the current version, look at Docker Hub to see what version I'm on.

```
# login to dockerhub
docker login

# build the image locally
docker build -t briandoconnor/anvil-rstudio-base:1.9 .

# try running the image, this will finish the install
docker run -it --rm -p 8001:8001 briandoconnor/anvil-rstudio-base:1.9

# now push to Dockerhub... normally I would have Dockerhub build this but the script I'm using to launch galaxy does install some additional stuff on first run. So I want to push the image after first run instead of automatically building.  In the long term this needs to be eliminated but OK for PoC.
docker push briandoconnor/anvil-rstudio-base:1.9
```

Then look in a browser at:

    http://localhost:8001/proxy/anvil-stage-demo/556f079a44bc/rstudio/

Replace 556f079a44bc with the docker container hostname

It also works to just go to local host on 8001 (nginx rewrites the URLs)

## Terminal

See https://github.com/microsoft/node-pty/tree/master/examples/electron
for the code I'm using for a basic terminal

See also:
* https://github.com/lovefishs/xterm-example


```
apt-get update; apt-get install build-essential python3-dev nodejs


```


## finding dependencies

This [site](https://packages.debian.org/search?mode=path&suite=buster&section=all&arch=any&searchon=contents&keywords=libasound.so.2) was very useful for finding packages




# AnVIL RStudio Docker Image

[Rstudio](https://rstudio.com/products/rstudio/) is an integrated development environment to support the R statistical programming language. The AnVIL RStudio Docker is a version-tagged image of RStudio, providing consistent RStudio software, packages, and dependencies with every use. This document describes the [RStudio](https://rstudio.com/products/rstudio/) Docker Image and how to use it in the cloud-based platform [Terra](app.terra.bio). Unlike the currently existing [Terra base images](https://github.com/DataBiosphere/terra-docker#terra-base-images), RStudio is not hosted in a Jupyter Notebook; any work performed in Terra RStudio will not be saved to a workspace google bucket. This document provides instructions and resources for saving RStudio data and code.

## Table of Contents
- [Accessing the AnVIL RStudio Image](#accessing-the-anvil-rstudio-image)
- [Using the RStudio Docker in Terra](#using-the-rstudio-docker-in-terra)
  * [Saving RStudio Data](#saving-rstudio-data)
    + [1. Copying RStudio work to a workspace google bucket](#1-copying-rstudio-work-to-a-workspace-google-bucket)
    + [2. Downloading RStudio files to your local computer](#2-downloading-rstudio-files-to-your-local-computer)
    + [3. Checking code into GitHub](#3-checking-code-into-github)
- [RStudio Docker Contents](#rstudio-docker-contents)
  * [Base Image](#base-image)
  * [Applications](#applications)
  * [Libraries](#libraries)
  * [Customizations](#customizations)
- [RStudio Docker Updates](#rstudio-docker-updates)


## Accessing the AnVIL RStudio Image

The AnVIL Rstudio Image can be accessed using the Docker Image URL specified in the table at the top of this document.

## Using the RStudio Docker in Terra

The RStudio Docker can be used in the cloud-based platform Terra. Detailed instructions on accessing the AnVIL RStudio image in Terra can be found in the "[Working with Project-Specific Environments in Terra](https://support.terra.bio/hc/en-us/articles/360037269472)" documentation in Terra support.

### Saving RStudio Data

Unlike in a Terra base Docker image, any work performed in a project-specific Docker (like RStudio) will not be saved to your workspace google bucket. While your code will be saved on the runtime environment, if you delete the runtime (or if your runtime becomes unresponsive), you will lose code. To avoid losing work, make sure to back up your code or save it using the following techniques.


#### 1. Copying RStudio work to a workspace google bucket

Use the [gsutil](https://cloud.google.com/storage/docs/gsutil) tool to copy files to your workspace google bucket. The "[Working with Project-Specific Environments in Terra](https://support.terra.bio/hc/en-us/articles/360037269472)" documentation in Terra support demonstrates how to identify the url for a workspace google bucket. After identifying the workspace google bucket url, you can copy files to a google bucket by navigating to them in your terminal and using the bash command:

    gsutil cp ./* gs://<WORKSPACE_BUCKET>

#### 2. Downloading RStudio files to your local computer
Once your files are copied to a workspace google bucket, you can access them by selecting the Data tab of the workspace and choosing the Files option on bottom left. This will display the files available in your google bucket. By selecting a file, you can download it directly. Additionally, [this Terra support document](https://support.terra.bio/hc/en-us/articles/360029251091-Broad-Genomics-Downloading-data-from-a-Terra-workspace) details alternative techniques you can use to download data files.

#### 3. Checking code into GitHub
You can install Git on RStudio and use it to [check code into GitHub](https://help.github.com/en/github/importing-your-projects-to-github).

## RStudio Docker Contents

### Base Image

The base image for the AnVIL RStudio Docker is the [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/) image provided by the [Rocker Project](https://www.rocker-project.org/). This image additionally contains tidyverse and devtools.

### Applications

The AnVIL R Docker contains the [RStudio Server](https://www.rstudio.com/products/rstudio-server/) application which supports a web browser version of RStudio.

### Libraries

The following packages are pre-loaded in the AnVIL RStudio image:

* [tidyverse](https://www.tidyverse.org/packages/): a suite of packages designed for data sciences
* [google-cloud-sdk](https://cloud.google.com/sdk/): tools for the google cloud platform
* [googleCloudStorageR](http://code.markedmondson.me/googleCloudStorageR/): an R library for interacting with google cloud storage
* [bigrquery](https://github.com/r-dbi/bigrquery): a package to allow interaction with Google's BigQuery
* [DataBiosphere/Ronaldo](https://github.com/DataBiosphere/Ronaldo): a package of functions commonly used for R Notebooks created from Leonardo

### Customizations

The AnVIL RStudio image is customized to disable the RStudio login screen. Future customizations will include:

* RStudio hooks to refresh credentials
* An RStudio auto pause after inactivity

## RStudio Docker Updates

All updates and changes to the current Docker image are listed in the Rstudio image [CHANGELOG.md file](CHANGELOG.md).
