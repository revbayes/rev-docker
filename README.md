# rev-docker

For using RevBayes with Docker

The RevBayes Docker image currently has the following applications and libraries installed:
- RevBayes
- TensorPhylo
- R
- Python
- Julia
- Java
- Beast/Beagle

The RevBayes Docker image can be found at [hub.docker.com/r/sswiston/rb_tp](https://hub.docker.com/r/sswiston/rb_tp), alongside a README containing information about different tag options and program versions.

For a full tutorial about using RevBayes with Docker: [revbayes.github.io/tutorials/docker/](https://revbayes.github.io/tutorials/docker/)

## Prerequisites
- Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Create DockerHub account and login
- Download the RevBayes Docker image by with this shell command: `docker pull sswiston/rb_tp:latest`

## Command-line job
- Open Docker Desktop to launch the Docker daemon
- Use helper script to launch a RevBayes container and execute a job script
    -  *Usage:* `./run_revbayes_docker.sh test.Rev my_job_name`
- Use `docker run` command to launch a RevBayes container and execute a job script
    - *Usage:* `docker run --name my_job_name --volume /Users/Sarah/projects/rev-docker:/mnt/project sswiston/rb_tp:latest rb /mnt/project/test.Rev"

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
  - ```shell
       cd /mnt/project
       rb test.Rev
       ```