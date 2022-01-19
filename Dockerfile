FROM andrewosh/binder-base

RUN apt-get update
RUN apt-get install -y libgdal-dev libproj-dev && apt-get clean
