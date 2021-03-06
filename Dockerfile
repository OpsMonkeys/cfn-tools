FROM amazon/aws-cli:2.1.29

ENV CFN_DOCS_VERSION=0.3.2
ENV CFN_GUARD_VERSION=1.0.0
ENV CFN_LINT_VERSION=0.46.0
ENV CFN_NAG_VERSION=0.7.2
ENV CHECKOV_VERSION=1.0.827

WORKDIR /bin

RUN yum install -y \
    git-2.23.3 \
    wget-1.14 \
    python3-3.7.9 \
    tar-1.26 \
    && \
    ## Install Ruby 2.6 for cfn-nag
    yum groupinstall -y "Development Tools" && \
    amazon-linux-extras install ruby2.6 && \
    yum install -y ruby-devel rubygems && \
    ## Install cfn-nag
    gem install cfn-nag:${CFN_NAG_VERSION} && \
    ## Install cfn-guard
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${CFN_GUARD_VERSION}/cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    mv cfn-guard-linux/cfn-guard . && \
    chmod +x cfn-guard && \
    rm -rf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    rm -rf cfn-guard-linux && \
    ## Install cfn-lint
    pip3 install cfn-lint==${CFN_LINT_VERSION} && \
    ## Install checkov
    pip3 install checkov==${CHECKOV_VERSION} && \
    ## Install cfn-docs
    pip3 install cloudformation-docs==${CFN_DOCS_VERSION} && \
    ## Clean up
    yum clean all

RUN useradd -b /home -d /home/cfn_user cfn_user

USER cfn_user

WORKDIR /home/cfn_user

COPY entrypoint.sh /home/cfn_user/entrypoint.sh

ENTRYPOINT ["/home/cfn_user/entrypoint.sh"]

