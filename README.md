# rev-docker

For using RevBayes with Docker

The RevBayes Docker image currently has the following applications and libraries installed (versions to be added):
- RevBayes
- TensorPhylo
- R
- Python

## Prerequisites
- Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Create DockerHub account and login
- Download the RevBayes Docker image by with this shell command: `docker pull sswiston/rb_tp:latest`

## GUI job
- Open Docker Desktop
- Go to Images tab
- Click Run on image you want to run (e.g. `sswiston/rb_tp:latest`)
- Optional settings:
  - Set container name (optional)
  - Set Volume -> Host Path: the location of the RevBayes project and scripts for the analysis (e.g. `/Users/Sarah/projects/rev-docker`)
  - Set Volume -> Container Path: the volume mount location within the container (e.g. `/mnt/project`)
- Click Run to boot container
- Go to Containers tab
- Click CLI for Command Line Interface
- Enter the container and run commands as needed, for example:
```shell
cd /mnt/project
rb test.Rev
```
  

## Command-line job
- Open Docker Desktop
  - *TBD: Can you run Docker daemon without opening Desktop?*
- Type command to launch a RevBayes container and execute a job script
docker run -v "/Users/Sarah/projects/rb_test:/rb_test sswiston/rb_tp:latest" "rb /rb_test/rb_test.Rev"
Use helper script to launch a RevBayes container and execute a job script


## Cluster job (WUSTL RIS example)
Login to cluster
Create cluster batch job script (bash):
Define variable to mount storage in Docker container filesystem
Define variable for where to store job output
Define variables to pass into script and define jobname
Construct a bsub command for each job we want to run using Docker
This command calls the RevBayes job script (3) once per submitted job
Create single RevBayes job script (bash):
Add path to RevBayes binary to PATH variable
apparently needed for RIS
Collect RevBayes analysis variables
Construct and echo RevBayes string for initialization settings, then pipe echo file into RevBayes command to run job
Create single RevBayes job script (Rev language):
Loads data, model, and runs MCMC
Output will be stored wherever RevBayes script (4) specifies




