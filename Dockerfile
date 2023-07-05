# BASE IMAGE
FROM dokken/debian-11

# BASE SOFTWARE
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends automake
RUN apt-get install -y --no-install-recommends autoconf
RUN apt-get -y install cmake protobuf-compiler
RUN apt-get -y install iputils-ping
RUN apt-get install -y --no-install-recommends git
RUN apt-get -y install libboost-all-dev
RUN apt-get -y install build-essential
RUN apt-get -y install gdebi-core
RUN apt-get clean

# JAVA
WORKDIR "/"
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk

# PYTHON
WORKDIR "/"
RUN apt-get install -y --no-install-recommends python3
RUN apt-get install -y python3-pip
RUN ln -s /usr/bin/python3 /usr/local/bin/python

# R 4.2.3
WORKDIR "/"
RUN su -
RUN grep '^deb ' /etc/apt/sources.list | perl -pe 's/deb /deb-src /' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y build-dep r-base
RUN curl -O https://cran.rstudio.com/src/base/R-4/R-4.2.3.tar.gz
RUN tar xzvf R-4.2.3.tar.gz ; rm R-4.2.3.tar.gz
WORKDIR "/R-4.2.3"
RUN ./configure --prefix=/opt/R/4.2.3 --enable-R-shlib --enable-memory-profiling
RUN make ; make install
ENV PATH /opt/R/4.2.3/bin:$PATH
RUN ln -s /opt/R/4.2.3/bin/R /usr/local/bin/R
RUN ln -s /opt/R/4.2.3/bin/Rscript /usr/local/bin/Rscript
ENV R_HOME /R-4.2.3
ENV R_LIBS_USER /R-4.2.3/library
ENV LD_LIBRARY_PATH /R-4.2.3/lib:$LD_LIBRARY_PATH

# JULIA
WORKDIR "/"
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
RUN tar xvfz julia-1.9.0-linux-x86_64.tar.gz ; rm julia-1.9.0-linux-x86_64.tar.gz
ENV PATH /julia-1.9.0/bin:$PATH
RUN ln -s /julia-1.9.0/bin/julia /usr/local/bin/julia
ENV JULIA_DEPOT_PATH /julia/.julia

# REVBAYES
WORKDIR "/"
RUN git clone https://github.com/revbayes/revbayes.git /revbayes
WORKDIR "/revbayes/"
RUN git checkout hawaii_fix
WORKDIR "/revbayes/projects/cmake/"
RUN ./build.sh
ENV PATH /revbayes/projects/cmake:$PATH
RUN ln -s /revbayes/projects/cmake/rb /usr/local/bin/rb

# TENSORPHYLO
WORKDIR "/"
RUN git clone https://bitbucket.org/mrmay/tensorphylo.git
WORKDIR "/tensorphylo/build/installer/"
RUN bash install.sh

# BEAST2
WORKDIR "/"
RUN wget https://github.com/CompEvol/beast2/releases/download/v2.7.4/BEAST.v2.7.4.Linux.x86.tgz
RUN tar zxvf BEAST.v2.7.4.Linux.x86.tgz ; rm BEAST.v2.7.4.Linux.x86.tgz
ENV PATH /beast/bin:$PATH
RUN ln -s /beast/bin/beast /usr/local/bin/beast

# BEAGLE
WORKDIR "/"
RUN git clone --depth=1 https://github.com/beagle-dev/beagle-lib.git
WORKDIR "/beagle-lib"
RUN mkdir build
WORKDIR "/beagle-lib/build"
RUN cmake .. ; make ; make install ; cpack .

# PYTHON PACKAGES (future)
#RUN python3 -m pip install ...
RUN python3 -m pip install dendropy
RUN python3 -m pip install biopython

# JULIA PACKAGES (future)
#RUN julia -e 'import Pkg; Pkg.add("---")'
RUN julia -e 'import Pkg; Pkg.update()'
RUN julia -e 'import Pkg; Pkg.add("StatsBase"); using StatsBase'
RUN julia -e 'import Pkg; Pkg.add("Combinatorics"); using Combinatorics'
RUN julia -e 'import Pkg; Pkg.add("Random"); using Random'
RUN julia -e 'import Pkg; Pkg.add("DelimitedFiles"); using DelimitedFiles'
RUN julia -e 'import Pkg; Pkg.add("PProf"); using PProf'
RUN julia -e 'import Pkg; Pkg.add("Distributions"); using Distributions'
RUN julia -e 'import Pkg; Pkg.add("StatsPlots"); using StatsPlots'
RUN julia -e 'import Pkg; Pkg.add("Plots"); using Plots'
RUN julia -e 'import Pkg; Pkg.add("Phylo"); using Phylo'
RUN julia -e 'import Pkg; Pkg.add("Optim"); using Optim'
RUN julia -e 'import Pkg; Pkg.add("RCall"); using RCall'
RUN julia -e 'import Pkg; Pkg.add("Tapestree"); using Tapestree'

# R PACKAGES (future)
# RUN R -e "install.packages('...',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('remotes',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('coda',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ape',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('diversitree',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('phangorn',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('MASS',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('phytools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('mvMORPH',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('geiger',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('TreeSim',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('FossilSim',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('corHMM',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('hisse',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tikzDevice',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('patchwork',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('gridExtra',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(remotes); remotes::install_github('Caetanods/ratematrix')"

# FINISHING
ENV HOME "/"
WORKDIR "/"

# Command for building Docker image:
# docker build -t sswiston/rb_tp:test .