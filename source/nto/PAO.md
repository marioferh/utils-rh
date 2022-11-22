# PAO deployment

After ocp v4.11 PAO its not anymore an operator and has been included in NTO.
New name is Performance Profile Controller but in this doc will also refer as PAO.

- Create PerformanceProfile
  Easiest way with PPC less bug prone and add many checkers in order to have correct PerformanceProfile

- Apply new PerformanceProfile
- Label the node
- Unpause MCP in order to apply changes
- Wait for the MCP to pick PerformanceProfile MC
- Wait for the MCP being updated (after some reboots)

```console
  oc get mcp -w
  NAME         CONFIG                 UPDATED   UPDATING   DEGRADED   MACHINECOUNT   READYMACHINECOUNT   UPDATEDMACHINECOUNT   DEGRADEDMACHINECOUNT
  master       rendered-master-       True      False      False      3              3                   3                     0
  worker       rendered-worker-       True      False      False      2              2                   2                     0
  worker-cnf   rendered-worker-cnf-   True      False      False      1              1                   1                     0
```

- Check if PerformanceProfile and Tuned has been applied correctly

There are some helper scripts to automatize the process:

- CLUSTER=manual make cluster-deploy-pao
- make cluster-label-worker-cnf
- CLUSTER=manual make cluster-wait-for-pao-mcp

PPC - Performance Profile Creator
MCP - Machine Config Pool
MC  - Machine Config
MCO - Machine Config Operator

Links:
PAO: <https://docs.openshift.com/container-platform/4.6/scalability_and_performance/cnf-performance-addon-operator-for-low-latency-nodes.html>
PPC <https://docs.openshift.com/container-platform/4.8/scalability_and_performance/cnf-create-performance-profiles.html>

NTO repo: <https://github.com/openshift/cluster-node-tuning-operator>
PAO repo: <https://github.com/openshift-kni/performance-addon-operators>
