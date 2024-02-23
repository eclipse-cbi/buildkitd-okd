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
      replicas: 5,
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
          nodeSelector: {
            "speed": "fast"
          },
          containers: [
            {
              name: "buildkitd",
              image: "moby/buildkit:v0.12.5",
              args: [
                "--addr",
                "tcp://0.0.0.0:1234",
              ],
              resources: {
                limits: {
                  cpu: "4000m",
                  memory: "8Gi",
                },
                requests: {
                  cpu: "2000m",
                  memory: "6Gi",
                },
              },
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