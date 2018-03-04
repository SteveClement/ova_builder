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
│       └── thehive_training-application.conf
├── http
│   └── ubuntu1604
│       └── preseed.cfg
├── scripts
│   └── thehive-training
│       ├── bootstrap.sh
│       ├── clean.sh
│       ├── configuration.sh
│       ├── installation.sh
│       ├── interfaces.sh
│       └── user.sh
├── thehive-training_virtualbox.json
└── thehive-training_vmware.json
```

- `conffiles/thehive-training` contains cortex and thehive application.conf files ready
  to setup the training VM
- `http/ubuntu1604/pressed.cfg` if ready to install Ubunutu server xenial 64bits (16.04)
- `scripts/thehive-training` contains all bootstrap scripts need to install and setup
  thehive, cortex and Cortex-Analyzers 

## Run

- Validate recipe  json file

```
packer validate thehive-training_virtualbox.json
```

- Build OVA file with virtualbox

```
packer build thehive-training_virtualbox.json
```

- Build OVA file with VMware Fusion


```
packer build thehive-training_vmware.json
```

`thehive-training.ova` file is built and placed in `output-thehive` folder created by packer program.
It is ready to be imported in VMware and Virtualbox.


