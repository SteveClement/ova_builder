# Building TheHive training VM

## Requirements

#### Virtualization solution

- Virtualbox
- VMWare Fusion with ovftool (https://www.vmware.com/support/developer/ovf/)

#### Additional softwares

- packer 


## Tree

```
.
├── README.md
├── conffiles
│   └── thehive-training
│       ├── cortex_training-application.conf
│       ├── issue
│       └── thehive_training-application.conf
├── http
│   └── thehive-training
│       └── preseed.cfg
├── scripts
│   └── thehive-training
│       ├── bootstrap.sh
│       ├── clean.sh
│       ├── configuration.sh
│       ├── init_cortex.sh
│       ├── installation.sh
│       ├── interfaces.sh
│       └── user.sh
├── thehive-training_virtualbox.json
└── thehive-training_vmware.json

```

- `conffiles/thehive-training` contains Cortex and Thehive application.conf files ready
  to setup the training VM
- `http/thehive-training/preseed.cfg` Ubuntu server Xenial 64bits (16.04) preseed file 
- `scripts/thehive-training` contains all bootstrap scripts needed to install and setup
  thehive, cortex and Cortex-Analyzers 

## Run

- Validate recipe  json file

```
packer validate thehive-training_vmware.json
```

- Build OVA file with virtualbox

```
packer build thehive-training_vmware.json
```

- Build OVA file with VMware Fusion


```
packer build thehive-training_vmware.json
```

`thehive-training.ova` file is built. It is ready to be imported in VMware and Virtualbox.


