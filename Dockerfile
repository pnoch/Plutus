# Dockerfile for plutus
# usage: docker build -t plutus:latest .
#

FROM ubuntu:22.10

ENV TZ="Asia/Bangkok"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	build-essential curl file git ruby-full locales linux-libc-dev bash gcc gcc-11 tzdata libgmp3-dev sudo && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
	
RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew
USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

RUN /home/linuxbrew/.linuxbrew/bin/brew update && \
	/home/linuxbrew/.linuxbrew/bin/brew install openssl@3 python@3.10
	
RUN /home/linuxbrew/.linuxbrew/bin/brew postinstall python@3.10
	
WORKDIR /plutus-miner

COPY . .

# RUN git clone https://github.com/Isaacdelly/Plutus.git .

# output patch
RUN echo "output patching to '/data/plutus.txt'" && \
sed -i 's/\x27plutus\.txt\x27/\x27\/data\/plutus\.txt\x27/g' ./plutus.py

RUN /home/linuxbrew/.linuxbrew/bin/pip3 install -r requirements.txt

ENTRYPOINT ["/home/linuxbrew/.linuxbrew/bin/python3", "plutus.py", "verbose=1", "cpu_count=85"]