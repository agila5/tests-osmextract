#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

apt-get --yes update
apt-get --yes install software-properties-common 
add-apt-repository ppa:ubuntugis/ubuntugis-unstable \

apt-get update -qq && apt-get -y --no-install-recommends install \
    libudunits2-dev \
    libreadline-dev \
    libssl-dev \
    libgdal-dev \
    gdal-bin \
    libgeos-dev \
    libproj-dev \
    libglpk-dev \
    libxt-dev  \
    libarchive-dev \
    libmagick++-dev \
    libreadline-dev \
    libssl-dev && \

## R dependencies
install2.r --error --skipmissing --skipinstalled -n "$NCPUS"\
    sf \
    jsonlite \
    knitr \
    lubridate \
    RSQLite \
    miniUI \
    rmarkdown &&\

R -e 'remotes::install_github("ropensci/osmextract", "update-geofabrik-zones", upgrade = "never")'

# Clean up
rm -rf /tmp/downloaded_packages
rm -rf /var/lib/apt/lists/*

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so
