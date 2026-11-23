# Fileion check

A GitHub Action that checks your build files against the [Fileion](https://fileion.com) catalogue. It reports, for each file, whether Fileion lists it and, if so, the software, version and source, in the job summary. It runs the [Fileion CLI](https://github.com/fileion/fileion-cli) (`fileion check`).

## Usage

```yaml
- uses: fileion/check-action@v0.1.0 # or pin a commit SHA
  with:
    files: dist/*.exe
```

Several patterns, one per line:

```yaml
- uses: fileion/check-action@v0.1.0
  with:
    files: |
      dist/*.exe
      dist/*.zip
    fail-on: never
    api-key: ${{ secrets.FILEION_API_KEY }} # optional
```

Works on `ubuntu`, `windows` and `macos` runners (x64 and arm64). It needs `bash`, `curl` and `jq`, which the GitHub-hosted runners have.

## Inputs

| Input | Required | Default | Meaning |
|---|---|---|---|
| `files` | yes | | A glob relative to the workspace, or several, one per line. Absolute paths and `..` are refused. `**` works on Linux and Windows runners; on macOS runners (bash 3.2) it acts like `*`, so name the folder. |
| `fail-on` | no | `never` | `never`: the step fails only on a usage, network or API error. `unknown`: it also fails when a file is not listed. |
| `api-key` | no | | A free Fileion API key, for more requests a minute. Passed to the CLI only through the `FILEION_API_KEY` environment variable (never as a flag) and masked in the log. |

## Outputs

| Output | Meaning |
|---|---|
| `listed` | Number of files Fileion lists. |
| `not-listed` | Number of files Fileion has no record of. |
| `results-file` | Path of the CLI's JSON output. |

## What you see

A table in the job summary: file, listed (yes or no), software, version and source. **Not listed** means Fileion has no record of that file. It is not a warning, and a new build is often not listed yet. That is why `fail-on` defaults to `never`.

## Privacy

Your files never leave the runner. The CLI hashes each file there and sends only the SHA-256 hashes to the public Fileion API (`https://fileion.com/api/v1`), in one request for up to 100 files. No telemetry. With no key the API allows 60 requests a minute per IP; a free key allows 300. Shared GitHub runner addresses can hit the keyless limit, so add a key if you see a rate limit error (exit code 4).

## Unsigned CLI, verified against the SHA-256 values in action.yml

The Fileion CLI is not code-signed yet. The action downloads the CLI binary for the runner from the pinned [v0.1.0 release](https://github.com/fileion/fileion-cli/releases/tag/v0.1.0) over HTTPS and compares its SHA-256 with the value for that file written in `action.yml`, copied from that release's `SHA256SUMS`. It stops the job if they differ, so a replaced release file is caught too. It runs no other downloaded code and uses no other actions.

## Licence

MIT, see [LICENSE](LICENSE). Provided as is. The CLI is MIT too.
