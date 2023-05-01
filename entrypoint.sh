#!/bin/sh -l

[ -z ${FAIL_ON_SEVERITY} ] || PARAM_FAIL_ON_SEVERITY="-f ${FAIL_ON_SEVERITY}"

if [ ! -z "${IGNORE_CVES}" ]; then
  echo "ignore:" > /config.yaml
  echo "Ignored CVEs:"
  for cve in ${IGNORE_CVES}; do
    echo "  - vulnerability: $cve" >> /config.yaml
    echo " - $cve"
  done
  PARAM_CONFIG="-c /config.yaml"
fi

/grype --add-cpes-if-none -o template -t /output_with_summary.tmpl ${PARAM_CONFIG} ${PARAM_FAIL_ON_SEVERITY} ${IMAGE}
