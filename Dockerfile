# Start with JupyterHub image.
FROM ccpbiosim/jupyterbase:v3.0.0

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Python Dependencies for the workshop
RUN conda install ipywidgets
RUN pip3 install jupyterhub-tmpauthenticator

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

# Copy startup script - not necessary in JHub 3.0.0?
#COPY --chown=1000:100 spawn-terminal.py /usr/local/bin/spawn-terminal.py

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
