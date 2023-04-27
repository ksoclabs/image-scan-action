FROM us.gcr.io/ksoc-public/image-scan:0.0.2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
