FROM golang
RUN  git clone app-repo
RUN  cd TechChallengeApp;./build.sh 
COPY start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]
