FROM python:3.8
#ubuntu:16.04


COPY script.sh /
COPY starboard /usr/local/bin

RUN chmod +x /script.sh

CMD ["/script.sh"]



