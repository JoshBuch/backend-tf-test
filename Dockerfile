FROM owasp/zap2docker-weekly
USER root
RUN apt-get update
RUN apt-get install -y sqlmap
RUN apt-get install -y nmap
RUN apt-get install -y nikto


WORKDIR /zap
COPY . /zap
RUN chmod +x sec_test.sh
ENTRYPOINT ["bash"] 
CMD ["/zap/sec_test.sh"]
