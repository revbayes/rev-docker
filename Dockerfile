# BASE IMAGE
FROM dokken/debian-11
# Other Versions: yyl10/debian10, dokken/ubuntu-22.10

# BASE SOFTWARE
RUN apt-get update 
RUN apt-get install -y --no-install-recommends curl 
RUN apt-get install -y --no-install-recommends r-base 
RUN apt-get install -y --no-install-recommends r-base-dev 
RUN apt-get install -y --no-install-recommends git 
RUN apt-get install -y --no-install-recommends python3 
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN apt-get install -y python3-pip
RUN apt-get install -y --no-install-recommends automake
RUN apt-get install -y --no-install-recommends autoconf  
RUN apt-get -y install cmake protobuf-compiler 
RUN apt-get -y install iputils-ping
RUN apt-get -y install libboost-all-dev
RUN apt-get clean 

# REVBAYES
RUN git clone https://github.com/revbayes/revbayes.git /revbayes
WORKDIR "/revbayes/"
RUN git checkout dev_fig_features
WORKDIR "/revbayes/projects/cmake/"
RUN ./build.sh
ENV PATH /revbayes/projects/cmake:$PATH

# TENSORPHYLO
WORKDIR "/"
RUN git clone https://bitbucket.org/mrmay/tensorphylo.git
WORKDIR "/tensorphylo/build/installer/"
RUN bash install.sh
WORKDIR "/"

# PACKAGES
RUN R -e "install.packages('ggplot2',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('patchwork',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('coda',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('phytools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('treesim',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('fossilsim',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('mvmorph',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('geiger',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('panda',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('diversitree',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('loganalyser',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ape',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN pip install dendropy
RUN pip install biopython

# Command for building Docker image:
# docker build -t sswiston/rb_tp:test .