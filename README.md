# Control-repo for Puppet-based infrastructure used in labs 5 and 6 in IMT3005 - Infrastructure as Code

*Based on [puppetlabs/control-repo](https://github.com/puppetlabs/control-repo). The original readme can be found [here](./original_readme.md).*

## Structure

Here's a visual representation of the structure of this repository:

```
control-repo/
├── data/                                 # Hiera data directory.
│   ├── nodes/                            # Node-specific data goes here.
│   └── common.yaml                       # Common data goes here.
├── manifests/
│   └── site.pp                           # The "main" manifest that contains a default node definition.
├── scripts/
│   ├── code_manager_config_version.rb    # A config_version script for Code Manager.
│   ├── config_version.rb                 # A config_version script for r10k.
│   └── config_version.sh                 # A wrapper that chooses the appropriate config_version script.
├── site/                                 # This directory contains site-specific modules and is added to $modulepath.
│   ├── profile/                          # The profile module.
│   └── role/                             # The role module.
├── LICENSE
├── Puppetfile                            # A list of external Puppet modules to deploy with an environment.
├── README.md
├── environment.conf                      # Environment-specific settings. Configures the moduelpath and config_version.
├── hiera.yaml                            # Hiera's configuration file. The Hiera hierarchy is defined here.
└── original_readme.md                    # Original readme from Puppetlabs.
```
