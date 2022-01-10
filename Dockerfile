FROM python:3
ENV LC_ALL=C.UTF-8 \
    IMAGEMAGICK_BINARY=/usr/bin/convert \
    FFMPEG_BINARY=/usr/bin/ffmpeg

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    ffmpeg \
    imagemagick \
    fonts-liberation  

RUN apt-get -y install locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN apt-get dist-upgrade -y

ADD . /var/src/moviepy/
WORKDIR /var/src/moviepy/
RUN pip install .[optional] && \
    jupyter \
    ipywidgets
RUN apt-get clean all && apt-get autoremove && rm -rf /var/lib/apt/lists/* /root/.cache/

# https://jupyter.org/install.html
# modify ImageMagick policy file so that Textclips work correctly.
RUN sed -i 's/none/read,write/g' /etc/ImageMagick-6/policy.xml 
CMD jupyter nbextension enable --py --sys-prefix widgetsnbextension
# CMD jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
