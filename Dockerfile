USER root
RUN apt-get update && apt-get install -y libgdal-dev gdal-bin libproj-dev

FROM rocker/rstudio:latest

RUN /rocker_scripts/install_binder.sh
