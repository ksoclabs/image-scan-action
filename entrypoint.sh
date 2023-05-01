#!/bin/sh -l

SARIF_OUTPUT_FILE_NAME="./sarif_output.json"

[ -z ${FAIL_ON_SEVERITY} ] || PARAM_FAIL_ON_SEVERITY="-f ${FAIL_ON_SEVERITY}"

# Handle "table" and "sarif" output formats.
if [ "${FORMAT}" = "table" ]; then
  PARAM_FORMAT="-o template -t /output_with_summary.tmpl"
elif [ "${FORMAT}" = "sarif" ]; then
  PARAM_FORMAT="-o sarif --file $SARIF_OUTPUT_FILE_NAME"
  echo "sarif=$SARIF_OUTPUT_FILE_NAME" >> $GITHUB_OUTPUT
fi

# Ignoring CVEs requires a config file.
if [ ! -z "${IGNORE_CVES}" ]; then
  echo "ignore:" > /config.yaml
  echo "Ignored CVEs:"
  for cve in ${IGNORE_CVES}; do
    echo "  - vulnerability: $cve" >> /config.yaml
    echo " - $cve"
  done
  PARAM_CONFIG="-c /config.yaml"
fi

/grype --add-cpes-if-none ${PARAM_FORMAT} ${PARAM_CONFIG} ${PARAM_FAIL_ON_SEVERITY} ${IMAGE}
exit_code=$?

# Add KSOC Image Scan reference to the SARIF report.
if [ "${FORMAT}" = "sarif" ]; then
  tmp=$(mktemp)
  jq '.runs[].tool.driver.name = "KSOC Image Scan using Grype"' $SARIF_OUTPUT_FILE_NAME > "$tmp" && mv "$tmp" $SARIF_OUTPUT_FILE_NAME
  chmod 644 $SARIF_OUTPUT_FILE_NAME
fi

exit $exit_code
