#!/bin/sh -l

[ -z ${FAIL_ON_SEVERITY} ] || PARAM_FAIL_ON_SEVERITY="-f ${FAIL_ON_SEVERITY}"

/grype -o template -t /output_with_summary.tmpl ${PARAM_FAIL_ON_SEVERITY} ${IMAGE}
