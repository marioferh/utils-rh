After apply a PerformanceProfile we can measure power consumptions.
It is neccesary to install in the cluster some packets:
https://access.redhat.com/downloads/content/package-browser
- Search for packages: kernel-tools and kernel-tools-libs
- Install it sudo rpm-ostree install --cache-only kernel-tools-*
- Reboot: sudo systemctl reboot


```
apiVersion: performance.openshift.io/v2
kind: PerformanceProfile
metadata:
  name: performance
spec:
  cpu:
    isolated: 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111
    reserved: 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110
  machineConfigPoolSelector:
    pools.operator.machineconfiguration.openshift.io/master: ""
  nodeSelector:
    node-role.kubernetes.io/master: ""
  numa:
    topologyPolicy: single-numa-node
  realTimeKernel:
    enabled: true
  workloadHints:
    highPowerConsumption: false
    perPodPowerManagement: true
    realTime: true

```

There are two ways to get measurements from RAPL https://lwn.net/Articles/545745/ https://web.eece.maine.edu/~vweaver/projects/rapl/ only on intel of recent generations

```
sudo turbostat --show PkgWatt -i 60
[...]
PkgWatt
200.12
102.84
97.29
```
or

```
sudo perf stat -a -e "power/energy-cores/" -a -I 100
➜  sudo perf stat -a -e "power/energy-cores/" -a -I 100
#           time             counts   unit events
     0.100167441               0.14 Joules power/energy-cores/
     0.200502577               0.09 Joules power/energy-cores/
     0.301000781               0.08 Joules power/energy-cores/
     0.401297705               0.11 Joules power/energy-cores/
```

```
BMC:
while sleep 10; do /opt/dell/srvadmin/bin/idracadm7 -r $SERVER  -u $USER -p $PASSWORD getsensorinfo | grep "System Board Pwr" | awk '{print $6}'; done
384Watts
384Watts
384Watts
384Watts
```
