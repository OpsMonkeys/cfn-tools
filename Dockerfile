FROM amazon/aws-cli:2.1.29

ENV CFN_GUARD_VERSION=1.0.0

WORKDIR /bin

RUN yum update && \
    yum install -y \
    git \
    wget \
    unzip \
    python3 \
    tar \
    && \
    ## Install CFN Guard
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${CFN_GUARD_VERSION}/cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    mv cfn-guard-linux/cfn-guard . && \
    chmod +x cfn-guard && \
    rm -rf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    rm -rf cfn-guard-linux && \
    # Install cfn-lint
    pip3 install cfn-lint
    
RUN useradd -b /home -d /home/cfn_user cfn_user

USER cfn_user

WORKDIR /home/cfn_user
# RUN  pip3 install cfn-lint

COPY entrypoint.sh /home/cfn_user/entrypoint.sh

ENTRYPOINT ["/home/cfn_user/entrypoint.sh"]

