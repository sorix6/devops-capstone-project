FROM nginx:1.17

COPY linux_tweet_app/index.html /usr/share/nginx/html
COPY linux_tweet_app/linux.png /usr/share/nginx/html

EXPOSE 80 443 	

CMD ["nginx", "-g", "daemon off;"]
