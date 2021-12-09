{
  apiVersion: "security.openshift.io/v1",
  kind: "SecurityContextConstraints",
  metadata: {
    annotations: {
      "kubernetes.io/description": "same as super-restricted, but do not drop setuid and setgid capabilities and add unconfined seccomp profile.",
    },
    name: "rootless",
  },
  allowHostDirVolumePlugin: false,
  allowHostIPC: false,
  allowHostNetwork: false,
  allowHostPID: false,
  allowHostPorts: false,
  allowPrivilegeEscalation: true,
  allowPrivilegedContainer: false,
  allowedCapabilities: null,
  defaultAddCapabilities: null,
  fsGroup: {
    type: "MustRunAs"
  },
  groups: [
  ],
  priority: null,
  readOnlyRootFilesystem: false,
  requiredDropCapabilities: [
    "KILL",
    "MKNOD",
  ],
  runAsUser: {
    type: "MustRunAsRange"
  },
  seLinuxContext: {
    type: "MustRunAs"
  },
  supplementalGroups: {
    type: "MustRunAs"
  },
  seccompProfiles: [
    "unconfined"
  ],
  users: [],
  volumes: [
    "configMap",
    "downwardAPI",
    "emptyDir",
    "persistentVolumeClaim",
    "projected",
    "secret"
  ]
}
