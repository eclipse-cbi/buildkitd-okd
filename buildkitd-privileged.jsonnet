[
  {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      labels: {
        app: "buildkitd"
      },
      name: "buildkitd",
      namespace: "foundation-internal-infra-buildkitd",
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: "buildkitd"
        }
      },
      template: {
        metadata: {
          labels: {
            app: "buildkitd"
          },
        },
        spec: {
          serviceAccountName: "buildkitd-privileged",
          containers: [
            {
              name: "buildkitd",
              image: "moby/buildkit:latest",
              args: [
                "--addr",
                "tcp://0.0.0.0:1234",
              ],
              readinessProbe: {
                exec: {
                  command: [
                    "buildctl",
                    "--addr",
                    "tcp://0.0.0.0:1234",
                    "debug",
                    "workers",
                  ]
                },
                initialDelaySeconds: 5,
                periodSeconds: 30
              },
              livenessProbe: {
                exec: {
                  command: [
                    "buildctl",
                    "--addr",
                    "tcp://0.0.0.0:1234",
                    "debug",
                    "workers",
                  ]
                },
                initialDelaySeconds: 5,
                periodSeconds: 30
              },
              securityContext: {
                privileged: true
              },
              ports: [
                {
                  containerPort: 1234
                }
              ],
            }
          ],
        }
      }
    }
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      labels: {
        app: "buildkitd"
      },
      name: "buildkitd",
      namespace: "foundation-internal-infra-buildkitd",
    },
    spec: {
      ports: [
        {
          port: 1234,
          protocol: "TCP"
        }
      ],
      selector: {
        app: "buildkitd"
      }
    }
  },
]