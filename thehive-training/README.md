# Building TheHive training VM

## Requirements

#### Virtualization solution

- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- [VMWare Workstation](https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-for-linux.html)

#### Additional softwares

- [packer](https://www.packer.io)

## Tree

```
.
├── README.md
├── conffiles
│   ├── thehive-cortex-misp-training
│   │   ├── cortex_training-application.conf -> ../thehive-training/cortex_training-application.conf
│   │   ├── issue
│   │   └── thehive_training-application.conf -> ../thehive-training/thehive_training-application.conf
│   └── thehive-training
│       ├── cortex_training-application.conf
│       ├── issue
│       └── thehive_training-application.conf
├── http
│   ├── thehive-cortex-misp-training
│   │   └── preseed.cfg
│   └── thehive-training
│       └── preseed.cfg
├── scripts
│   ├── thehive-cortex-misp-training
│   │   ├── clean.sh -> ../thehive-training/clean.sh
│   │   ├── configuration.sh
│   │   ├── init_cortex.sh -> ../thehive-training/init_cortex.sh
│   │   ├── init_thehive.sh -> ../thehive-training/init_thehive.sh
│   │   ├── installation.sh -> ../thehive-training/installation.sh
│   │   ├── interfaces.sh -> ../thehive-training/interfaces.sh
│   │   ├── misp-bootstrap.sh
│   │   └── user.sh
│   └── thehive-training
│       ├── clean.sh
│       ├── configuration.sh
│       ├── init_cortex.sh
│       ├── init_thehive.sh
│       ├── installation.sh
│       ├── interfaces.sh
│       └── user.sh
├── thehive-cortex-misp_virtualbox.json
├── thehive-training_virtualbox.json
└── thehive-training_vmware.json
```

- `conffiles/thehive-training` contains Cortex and Thehive application.conf files ready
  to setup the training VM
- `http/thehive-training/preseed.cfg` Ubuntu server 64bits (18.04.1) preseed file
- `scripts/thehive-training` contains all bootstrap scripts needed to install and setup
  thehive, cortex and Cortex-Analyzers


## Run

### Build TheHive training VM 

- Validate recipe json file

```
packer validate thehive-training_virtualbox.json
```

- Build OVA file with virtualbox

```
packer build thehive-training_virtualbox.json
```

`thehive-training.ova` file is built and stored in a new folder called `output-thehive`. It is ready to be imported in VMware or Virtualbox.

#### Build a VM with TheHive, Cortex and MISP

- Validate recipe json file

```
packer validate thehive-cortex-misp.json
```

- Build OVA file for virtualbox

```
packer build -only=virtualbox-iso thehive-cortex-misp.json
```

`thehive-misp.ova` file is built and stored in a new folder called `output-thehive-misp`. It is ready to be imported in VMware or Virtualbox.
If you have issues with the OVA on VMware generate a native VMWare image.

- Build VM-Image file for VMWare

```
packer build -only=vmware-iso thehive-cortex-misp.json
```

