# NTO

NTO its a cluster node operator, thus, is installed with ocp. 

To generate custom PAO inside NTO just modify PAO and create a new image with build.sh script.

To test custom NTO image:
  - launch build.sh
  - Select a operator manifest
  - Change source of container image to install:
    ```
      containers:
        - name: cluster-node-tuning-operator
          image: quay.io/user/cluster-node-tuning-operator:4.12_hints_v1
    ```
  - Launch scale: oc scale deploy/cluster-version-operator --replicas=0 -n openshift-cluster-version 
  - Apply manifest: oc apply -f manifest/

Now custom NTO image is installed, continue with PAO deployment.
