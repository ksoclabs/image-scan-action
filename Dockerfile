FROM us.gcr.io/ksoc-public/image-scan:0.0.2

RUN apk add --no-cache jq

COPY entrypoint.sh /entrypoint.sh
COPY output_with_summary.tmpl /output_with_summary.tmpl

ENTRYPOINT ["/entrypoint.sh"]
