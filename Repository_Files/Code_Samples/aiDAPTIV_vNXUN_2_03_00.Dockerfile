FROM ubuntu:22.04
ARG tar_name 
ARG deploy_sh_file_name 
COPY ${tar_name} ./tar/${tar_name} 
COPY ${deploy_sh_file_name} ${deploy_sh_file_name} 
ENV tar_path="./tar/${tar_name}"
ENV LANG=C.UTF-8
RUN apt-get update \ 
        && apt-get -y install apt-utils \
        && apt-get -y install wget \
        && apt-get -y install sudo  \
        && apt-get -y install libcap2-bin \ 
        && apt-get -y install lshw \
        && apt-get -y install pciutils \
        && apt-get update 
RUN chmod +x ${deploy_sh_file_name} 
RUN bash -c '/bin/echo -e "1\nn\nn\n${tar_path}\n2" | bash  ${deploy_sh_file_name}'
RUN rm -rf /root/.cache/*   \
        && rm -rf ./tar/${tar_name} \
        && rm -rf ${deploy_sh_file_name} 
