# Bitbucket Pipelines Pipe: AAA Sentinel deploy marker

Records each deployment in [AAA Sentinel](https://app.aaa-sentinel.com), so cost anomalies and
monitoring incidents show what was deployed right before them. Deployment markers are part of the
Pro and Business plans.

## YAML Definition

Add this step after the step that deploys:

```yaml
- step:
    name: Record the deployment in AAA Sentinel
    script:
      - pipe: docker://public.ecr.aws/u1c8u4c5/deploy-marker:1
        variables:
          SENTINEL_CLIENT_ID: $SENTINEL_CLIENT_ID
          SENTINEL_CLIENT_SECRET: $SENTINEL_CLIENT_SECRET
          SERVICE: 'checkout-api'
          ENVIRONMENT: 'production'
          # ACCOUNT_ID: '<AAA Sentinel cloud account>'           # optional
          # MONITORING_SERVICE_ID: '<AAA Sentinel service id>'   # optional
```

Store `SENTINEL_CLIENT_ID` and `SENTINEL_CLIENT_SECRET` as secured repository or deployment
variables. They come from an OAuth2 app created in AAA Sentinel (Developer → Apps) with only the
`deployments:write` scope.

## Variables

| Variable | Required | Default | Usage |
| --- | --- | --- | --- |
| `SENTINEL_CLIENT_ID` | yes | | Client id of the OAuth2 app |
| `SENTINEL_CLIENT_SECRET` | yes | | Client secret of the OAuth2 app |
| `SERVICE` | yes | | Service deployed: lowercase letters, digits, `.`, `_` and `-` |
| `ENVIRONMENT` | yes | | Environment, same format (e.g. `production`) |
| `VERSION` | no | `$BITBUCKET_COMMIT` | Version deployed, up to 128 characters |
| `COMMIT_SHA` | no | `$BITBUCKET_COMMIT` | Commit deployed |
| `ACCOUNT_ID` | no | | AAA Sentinel cloud account the service runs in: its cost anomalies list this deployment |
| `MONITORING_SERVICE_ID` | no | | AAA Sentinel monitoring service: its incidents list this deployment |
| `URL` | no | this pipeline | Link shown next to the marker (https) |
| `RUN_ID` | no | the pipeline UUID | Rerunning the step does not create a second marker; a new pipeline for the same version does |
| `STARTED_AT`, `FINISHED_AT` | no | now | ISO 8601 times of the deployment |
| `FAIL_ON_ERROR` | no | `false` | Fail the step when the marker cannot be recorded |
| `API_URL` | no | `https://api.aaa-sentinel.com` | AAA Sentinel API base URL |

## Failures

A marker should never take a deployment down. Any failure (a wrong secret, a missing scope, an
invalid service name, an API that cannot be reached, a 429 or a 5xx) logs a warning with the
reason and the step succeeds; set `FAIL_ON_ERROR: 'true'` to fail it instead.

The marker carries no author, name or email: only what was deployed, where and when.

## License

MIT
