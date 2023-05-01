# KSOC Image Scan Action

KSOC scans for CVEs in your images as part of your GitHub Actions CI workflow.

This action is using Grype to scan for CVEs in given image.

## Example Usage

Build a local image and scan it for CVEs. It will fail the workflow if any CVE with `medium` severity is found. It will ignore CVEs with IDs `CVE-2021-1234` and `CVE-2021-5678`. Default output format will be used (`table`) which will be printed to the standard output of the action.

```yaml
name: ksoc-image-scan

on:
  pull_request:

jobs:
  ksoc-image-scan:
    permissions:
      # only required for workflows in private repositories
      actions: read
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: Build Local Container
        uses: docker/build-push-action@v4
        with:
          tags: localbuild/testimage:latest
          push: false
          load: true
      - name: KSOC Image Scan
        uses: ksoclabs/image-scan-action@v0.0.4
        with:
          fail_on_severity: medium
          ignore_cves: |
            CVE-2021-1234
            CVE-2021-5678
          image: localbuild/testimage:latest
```

This action also supports SARIF output format. Note the additional permission `security-events: write` which is required to upload security report.

```yaml
name: ksoc-image-scan

on:
  pull_request:

jobs:
  ksoc-image-scan:
    permissions:
      # required for all workflows
      security-events: write
      # only required for workflows in private repositories
      actions: read
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: Build Local Container
        uses: docker/build-push-action@v4
        with:
          tags: localbuild/testimage:latest
          push: false
          load: true
      - name: KSOC Image Scan
        id: scan
        uses: ksoclabs/image-scan-action@v0.0.4
        with:
          fail_on_severity: medium
          format: sarif
          ignore_cves: |
            CVE-2021-1234
            CVE-2021-5678
          image: localbuild/testimage:latest
      - name: Upload Image Scan SARIF Report
        if: success() || failure()
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: ${{ steps.scan.outputs.sarif }}
```

## Inputs

- `fail_on_severity`: The severity level that will cause the action to fail. If not provided, the action doesn't fail. Possible values are `negligible`, `low`, `medium`, `high` and `critical`.
- `format`: The output format of the action. Possible values are `table` and `sarif`. If not provided, the default value is `table`.
- `ignore_cves`: A multiline string of CVEs to ignore. Each line should contain a single CVE ID. If not provided, no CVEs will be ignored.
- `image`: The image to scan. This is a required input.

## Outputs

- `sarif`: Location of the SARIF output file of the action. This output is only available if `format` input is set to `sarif`.
