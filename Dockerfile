FROM scrapinghub/base:12.04
RUN apt-get update -qq &&\
    apt-get install -qy python-software-properties nginx git

# nodejs
RUN apt-add-repository ppa:chris-lea/node.js &&\
    apt-get update -qq &&\
    apt-get install -qy nodejs

# Install python stuff.
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD . /app

RUN ln -sf /app/nginx/nginx.conf /etc/nginx/nginx.conf

RUN pip install -e /app/slybot

EXPOSE 9001
# TODO(dangra): fix handling of nginx service, it won't be restarted in case if crashed.
CMD service nginx start; twistd --pidfile=/tmp/twistd.pid -n slyd -p 9002
