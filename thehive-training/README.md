# Building TheHive training VM

## Requirements

- Virtualbox
- packer 
- vagrant (optional)


## Tree

```
.
├── README.md
├── Vagrantfile
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
├── thehive-training.json
└── thehive-training_with_vagrant.json
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
packer validate thehive-training.json
```

- Build OVA file

```
packer build thehive-training.json
```

- Build OVA and .box file for Vagrant

```
packer build thehive-training_with_vagrant.json
```

`thehive-training.ova` file is built in `output-thehive` folder created by packer program.
It is ready to be imported in VMware and Virtualbox.


