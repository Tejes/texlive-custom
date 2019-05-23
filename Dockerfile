FROM debian:stretch-slim

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                wget \
                xzdec \
                ca-certificates \
                perl \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Download the latest TeX Live installer
RUN wget -nv http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        && tar -xzvf install-tl-unx.tar.gz

# Little bit hacky cd
RUN cd `echo /root/install-tl-20*` \
        && echo "selected_scheme scheme-custom\ncollection-basic 1\ncollection-fontsrecommended 1" >> texlive.profile \
        && ./install-tl -profile texlive.profile \
        && cd /root \
        && rm -rf ./install-tl*

# The year may need to be altered 
ENV PATH="${PATH}:/usr/local/texlive/2019/bin/x86_64-linux"

# Hungarian language support
RUN tlmgr install babel-hungarian hyphen-hungarian

# Frequently needed packages
RUN tlmgr install hyperref latex latex-bin latex-fonts oberdiek psnfss tools url

# Additional packages needed by my documents. Feel free to alter them
RUN tlmgr install booktabs diagbox enumitem fancyhdr fp geometry listings mdwtools pict2e setspace todo xcolor
