FROM ubuntu:16.04

# install python and conda
# to accelerate ubuntu apt source
#RUN sed -i "s/archive\.ubuntu\.com/mirrors\.163\.com/g" /etc/apt/sources.list && \
#	sed -i "s/security\.ubuntu\.com/mirrors\.163\.com/g" /etc/apt/sources.list
RUN	apt-get update && apt-get install -y python3 git wget bzip2 vim && \
	rm -rf /var/lib/apt/lists/* && \
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b
ENV PATH /root/miniconda3/bin:$PATH

# install deps
COPY environment.yml /
# set tsinghua conda and pip mirrors
#RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
#	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
#	pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN	conda env create -f environment.yml

# source activate need bash
RUN ln -fs /bin/bash /bin/sh

# setup notedown
RUN source activate gluon && \
    pip install https://github.com/mli/notedown/tarball/master && \
    mkdir notebook && \
    jupyter notebook --allow-root --generate-config && \
    echo "c.NotebookApp.contents_manager_class = 'notedown.NotedownContentsManager'" >>~/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

# copy notebooks
RUN  mkdir /root/d2l-zh
COPY / /root/d2l-zh/

# sanity check
# RUN source activate gluon && notedown --run /gluon-tutorials-zh/chapter_crashcourse/ndarray.md

# for chinese supports
ENV LANG C.UTF-8

# for user massage
RUN echo $'\n*# To activate this environment, use:\n\
*# > source activate gluon\n\
*#\n\
*# To deactivate an active environment, use:\n\
*# > source deactivate\n\
*#\n\
*# To get notebook token\n\
*# > jupyter notebook list\n'\
>> /etc/motd
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /root/.bashrc && \
    ln -fs /root/d2l-zh/.vimrc /root/.vimrc

CMD source activate gluon && \
    jupyter notebook --ip=0.0.0.0 --allow-root --notebook-dir /root/d2l-zh/
