WorkloadHints introduced in 4.11
New API should make it easier to configure nodes for specific types of workloads 

Links: https://github.com/openshift/cluster-node-tuning-operator/pull/339

Docs: https://github.com/openshift/openshift-docs/pull/46293


## - API changes

New field in performanceProfile.yaml

```
spec:
  workloadHints:
    realTime: true
...
spec:
  workloadHints:
    highPowerConsumption: false
```


**API types:**

```
// WorkloadHints defines the set of upper level flags for different type of workloads.
type WorkloadHints struct {
	// HighPowerConsumption defines if the node should be configured in high power consumption mode.
	// The flag will affect the power consumption but will improve the CPUs latency.
	// +optional
	HighPowerConsumption *bool `json:"highPowerConsumption,omitempty"`
	// RealTime defines if the node should be configured for the real time workload.
	// +default=true
	// +optional
	RealTime *bool `json:"realTime,omitempty"`
}
```

Keep in mind RealTime default=true


**tuned.conf:**

Tuned profile has a separate set of kernel arguments for each workload hint.
There are two WorkloadHints with following kernel arguments:

realTime:
```
cmdline_realtime=+nohz_full=${isolated_cores} tsc=nowatchdog nosoftlockup nmi_watchdog=0 
mce=off skew_tick=1
```
    
highPowerConsumption:
```
cmdline_power_performance=+processor.max_cstate=1 intel_idle.max_cstate=0 intel_pstate=disable
```


highPowerConsumption & realTime:
```
cmdline_idle_poll=+idle=poll
```

More info about kernel boot parameters: https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html


## - Create profile with PPC
A Performance Profile can be generated with PPC: 

```
podman run --entrypoint performance-profile-creator -v /must-gather:/must-gather:z registry.redhat.io/openshift4/performance-addon-rhel8-operator:v4.11 --mcp-name=worker-cnf --reserved-cpu-count=20 --rt-kernel=true --split-reserved-cpus-across-numa=false --topology-manager-policy=single-numa-node --must-gather-dir-path /must-gather  --power-consumption-mode=ultra-low-latency > my-performance-profile.yaml 
```

Power-consumption-mode is the parameter related with workloadHints. There are three modes:

```
Default: cpu partitioning with enabled power management and the basic reduction of latency figures

Low-latency: Adds some of real time behaviour

Ultra-low-latency: disables power management to get the max possible determinism and lowest latency
```



Now power consumption modes will work together with workload hints:
low-latency -> enable real-time workload hint
ultra-low-latency -> enable realtime and highPowerConsumtion hints

## - Applying hints

Apply performanceProfile with selected Workload Hints (as previous example)
Tuned config is created from performanceProfile
Tuned config is applied after reboot.
Check in the node that arguments has been applied correctly, in cmdline or just check if correct tuned config has been applied

```
sh-4.4# cat /proc/cmdline
BOOT_IMAGE=(hd0,gpt3)/ostree/rhcos-72e12bd65d4a09b523e4624c7f82855ff2bda2e8458a9880ff1409b544855723/vmlinuz-4.18.0-372.9.1.el8.x86_64 random.trust_cpu=on console=tty0 console=ttyS0,115200n8 ostree=/ostree/boot.0/rhcos/72e12bd65d4a09b523e4624c7f82855ff2bda2e8458a9880ff1409b544855723/0 ignition.platform.id=gcp root=UUID=71a9905c-7649-4043-9840-a6b7a448912d rw rootflags=prjquota boot=UUID=63de4183-89a6-4cbe-aebf-55fbf12ac118 skew_tick=1 nohz=on rcu_nocbs=1 tuned.non_isolcpus=00000001 systemd.cpu_affinity=0 intel_iommu=on iommu=pt isolcpus=managed_irq,1 nohz_full=1 tsc=nowatchdog nosoftlockup nmi_watchdog=0 mce=off skew_tick=1 processor.max_cstate=1 intel_idle.max_cstate=0 intel_pstate=disable idle=poll default_hugepagesz=1G hugepagesz=2M hugepages=128 +

```


## - Important

Don't mix realTime Kernel parameter and realTimeHint