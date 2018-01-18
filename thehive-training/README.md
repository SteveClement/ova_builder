# Building TheHive training VM

## Requirements

#### Virtualization solution

- Virtualbox
- VMWare Fusion with ovftool (https://www.vmware.com/support/developer/ovf/)

#### Additional softwares

- packer 
- vagrant (optional)


## Tree

```
.
├── README.md
├── conffiles
│   ├── cortex_training-application.conf
│   └── thehive_training-application.conf
├── http
│   └── preseed.cfg
├── scripts
│   ├── bootstrap.sh
│   ├── clean.sh
│   ├── configuration.sh
│   ├── installation.sh
│   ├── interfaces.sh
│   └── user.sh
├── thehive-training_virtualbox.json
└── thehive-training_vmware.json
```

- `Vagrantfile` is used to init and start a vagrant box created by packer
- `conffiles` contains cortex and thehive application.conf files ready
  to setup the training VM
- `http/pressed.cfg` if ready to install Ubunutu server xenial 64bits (16.04)
- `scripts` contains all bootstrap scripts need to install and setup
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


