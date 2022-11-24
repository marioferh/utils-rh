## Developent

Provide the ability through the performance addon operator to offline a set of unused cpus to reduce the overall power consumption of the cluster.

https://github.com/openshift/cluster-node-tuning-operator/pull/345



## Profile

Launch PerformanceProfile with field offlined:

cpu:
isolated: "1-2"
reserved: "0"
offlined: "4"

check if offlined cpu are offline:
sh-4.4# cat /sys/devices/system/cpu/offline
4

## PPC

To calculate offlined cpus we take into account the following input parameters:

    offlined-cpu-count : the number of cpus the user wants to set offline.
    disable-ht: Marks if the user want to disable logical processor siblings to disable hyperthreading
    power-consumption-mode: values: “default”, “low-latency”, “ultra-low-latency”


https://github.com/openshift/cluster-node-tuning-operator/pull/354

