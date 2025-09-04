# Code Samples

What we are looking for in this section is the following
Working config files for basic training situations.  The intention is that a customer could take one of these projects and get directly to training a model.
For this, each project folder will need to contain
1)	Readme with system configuration and description of what the config files are designed to do.  (see below for an example)
2)	Configuration files, for Middleware there are two YAML file, both of these need to be included
3)	Sample dataset, this does not need to be the complete dataset but, an accurate representation of what the dataset configuration is for the example.  That way the user can configure their dataset to match or, make a modification if needed.
The intention is that users would be directed to Phison.com to download the software.  If Phison would rather the software be available on a public repository then please let us know.

Example template  
System configuration  
Intel w5-3435X  
512GB DRAM  
2x 2T Pascari AI100  
4x 6000 ADA 48GB  

With this example you will be able to Fine Tune Train the popular Llama 3.1 70B LLM.  The workstation used for this example is configured for optimal performance when using aiDAPTIV Link.  By splitting the offload data across multiple AI100 SSDs we can increase the throughput of the data transfer and lower the training time.
GPU configuration is a very important factor and while aiDAPTIV Link will effectively run on a single GPU workstation we have configured this example to use all four GPUs.
[Attach the YAML files used to achieve this training situation, assume that the system has been configured using the installation guide/script and that the configuration files and models are located in the user /home directory eg /models, /configs]

To start this section out I want to see at least four+ configuration examples (or suggest samples)
1)	Llama 3.1 8B SFT (Single GPU)
2)	Llama 3.1 70B SFT (4x GPU)
3)	Falcon 180B SFT (Single GPU)  - This example can be ANY large LLM on a single GPU,  the intention is to show that with aiDAPTIVLink the user can train extremely large models that often cannot run on the system doing the training.
4)	Any QLORA training example
5)	Include any other popular LLMs and their system config.  We are not concerned with Inference or quantization, 

