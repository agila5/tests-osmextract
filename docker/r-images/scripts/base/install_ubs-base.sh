#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

apt-get update -qq && apt-get -y --no-install-recommends install \
    less \
    ssh \
    vim \
    zsh \
    mc \
    ranger \
    silversearcher-ag \
    parallel \
    hwloc \
    tasksel \
    numactl \
    inxi \
    libmagick++-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff-dev \
    libjpeg-dev \
    htop && \

## Setup CRAN and parallel installation
mkdir -p ~/.R
echo 'MAKEFLAGS = -j15' >> ~/.R/Makevars
echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> ${R_HOME}/etc/Rprofile.site

## R benchmarks
install2.r --error --skipmissing --skipinstalled -n "$NCPUS"\
    usethis \
    remotes \
    cli \
    ps \
    ragg \
    reprex \
    styler \
    quarto \
    roxygen2 \
    here \
    rstudioapi && \

# Clean up
rm -rf /tmp/downloaded_packages
rm -rf /var/lib/apt/lists/*

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so
