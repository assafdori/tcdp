FROM nginx:1.17.1-alpine

COPY index.html /usr/share/nginx/html
COPY main.py /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

USER root
