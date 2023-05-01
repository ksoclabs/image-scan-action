# KSOC Image Scan Action

KSOC scans for CVEs in your images as part of your GitHub Actions CI workflow.

This action is using Grype to scan for CVEs in given image.

## Example Usage

```yaml
name: ksoc-image-scan

on:
  pull_request:

jobs:
  ksoc-image-scan:
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: build local container
        uses: docker/build-push-action@v4
        with:
          tags: localbuild/testimage:latest
          push: false
          load: true
      - name: KSOC Image Scan
        uses: ksoclabs/image-scan-action@v0.0.3
        with:
          fail_on_severity: "medium"
          ignore_cves: |
            CVE-2021-1234
            CVE-2021-5678
          image: "localbuild/testimage:latest"
```

Above example shows how to build a local image and scan it for CVEs. It will fail the workflow if any CVE with `medium` severity is found. If `fail_on_severity` input is not provided, the action won't fail.

## Inputs

- `fail_on_severity`: The severity level that will cause the action to fail. If not provided, the action doesn't fail. Possible values are `negligible`, `low`, `medium`, `high` and `critical`.
- `ignore_cves`: A multiline string of CVEs to ignore. Each line should contain a single CVE ID. If not provided, no CVEs will be ignored.
- `image`: The image to scan. This is a required input.
