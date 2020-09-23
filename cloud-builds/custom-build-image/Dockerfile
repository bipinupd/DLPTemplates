FROM ubuntu

COPY requirements.txt .
RUN apt-get update && \
    apt-get -y install zip && \
    apt-get install -y jq && \
    apt-get install -y curl python3-venv python3-dev build-essential
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh && \
    apt-get install -y nodejs
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN apt-get install -y nodejs
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y
RUN curl -o /tmp/get-pip.py "https://bootstrap.pypa.io/get-pip.py" \
    && python3 /tmp/get-pip.py \
    && apt-get remove -y curl \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN pip install -r requirements.txt 
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]