FROM ubuntu:18.04

LABEL maintainer="Connor Goddard <hello@connorlukegoddard.com>"

ENV JUPYTER_PASSWORD=ml
ENV JUPYTER_PORT=8888

COPY ./assets/ /assets/

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        libssl-dev \
        libffi-dev \
        python3-dev \
        software-properties-common \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y python3.6

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 ./get-pip.py

RUN pip install -r /assets/requirements.txt

# Set up our notebook config.
COPY ./assets/jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062

RUN cp /assets/run_jupyter.sh / && \
    cp /assets/run_jupyterlab.sh / && \
    rm -rf /assets

# IPython
EXPOSE 8888

CMD ["/run_jupyterlab.sh", "--allow-root"]