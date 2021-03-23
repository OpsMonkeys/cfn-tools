FROM amazon/aws-cli:2.1.29

ENV CFN_DOCS_VERSION=0.3.2
ENV CFN_GUARD_VERSION=1.0.0
ENV CFN_LINT_VERSION=0.46.0
ENV CFN_NAG_VERSION=0.7.2
ENV CHECKOV_VERSION=1.0.827
ENV REVIEWDOG_VERSION=0.11.0
ENV RUBOCOP_VERSION=1.11.0
ENV RUBY_VERSION=2.7.2

WORKDIR /bin

SHELL [ "/bin/bash", "-l", "-c" ]

RUN yum install -y \
    git-2.23.3 \
    wget-1.14 \
    python3-3.7.9 \
    tar-1.26 \
    which-2.20 \
    procps-ng-3.3.10 \
    && \
    ## Install Development tools
    yum groupinstall -y "Development Tools" && \
    # amazon-linux-extras install ruby2.6 && \
    # yum install -y ruby-devel rubygems && \
    ## Install RVM and Ruby 2.7
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | sh -s stable && \
    source /usr/local/rvm/scripts/rvm && \
    rvm install ${RUBY_VERSION} && \
    rvm use ${RUBY_VERSION} --default && \
    rvm alias create default ${RUBY_VERSION} && \
    ## Install cfn-nag
    gem install cfn-nag:${CFN_NAG_VERSION} && \
    ## Install inspec
    wget -O - -q https://omnitruck.chef.io/install.sh | sh -s -- -P inspec && \
    ## Install rubocop
    gem install rubocop:${RUBOCOP_VERSION} && \
    ## Install cfn-guard
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${CFN_GUARD_VERSION}/cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    mv cfn-guard-linux/cfn-guard . && \
    chmod +x cfn-guard && \
    rm -rf cfn-guard-linux-${CFN_GUARD_VERSION}.tar.gz && \
    rm -rf cfn-guard-linux && \
    ## Install cfn-lint
    pip3 install --no-cache-dir cfn-lint==${CFN_LINT_VERSION} && \
    ## Install checkov
    pip3 install --no-cache-dir checkov==${CHECKOV_VERSION} && \
    ## Install cfn-docs
    pip3 install --no-cache-dir cloudformation-docs==${CFN_DOCS_VERSION} && \
    ## install reviewdog
    wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ v${REVIEWDOG_VERSION} && \
    ## Clean up
    yum remove ruby -y && \
    yum clean all

RUN useradd -b /home -d /home/cfn_user -g rvm cfn_user

USER cfn_user

WORKDIR /home/cfn_user

RUN mkdir cfn

COPY entrypoint.sh /home/cfn_user/entrypoint.sh

ENTRYPOINT ["/home/cfn_user/entrypoint.sh"]
