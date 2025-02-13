# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-codeentropy-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on CodeEntropy."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Python Dependencies for the workshop
RUN conda install ipywidgets

# Clone and install codeentropy
RUN git clone https://github.com/CCPBioSim/CodeEntropy.git && \
    cd CodeEntropy && \
    pip install . && \
    cd .. && \
    rm -r CodeEntropy

# Clone workshop contents
RUN git clone https://github.com/CCPBioSim/codeentropy-workshop.git && \
    mv codeentropy-workshop/* . && \
    rm -r codeentropy-workshop

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
