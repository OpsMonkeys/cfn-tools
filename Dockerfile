FROM amazon/aws-cli:2.4.0

ENV CFN_DOCS_VERSION=0.3.2
ENV CFN_GUARD_VERSION=2.0.4
ENV CFN_LINT_VERSION=0.56.1
ENV CFN_NAG_VERSION=0.8.8
ENV CHECKOV_VERSION=2.0.591
ENV HADOLINT_VERSION=2.8.0
ENV REVIEWDOG_VERSION=0.13.0
ENV RUBOCOP_VERSION=1.23.0
ENV YQ_VERSION=2.12.2

WORKDIR /bin

RUN yum install -y \
    git-2.23.4 \
    wget-1.14 \
    python3-3.7.9 \
    tar-1.26 \
    jq-1.5 \
    && \
    ## Install Development tools
    yum groupinstall -y "Development Tools" && \
    ## Install Ruby 2.6 for cfn-nag
    amazon-linux-extras install ruby2.6 && \
    yum install -y ruby-devel-2.6.8 && \
    ## Update webrick CVE's CVE-2020-25613
    gem install --default webrick:1.7.0 && \
    ## Install cfn-nag
    gem install cfn-nag:${CFN_NAG_VERSION} && \
    ## Install inspec
    wget -O - -q --progress=dot:giga https://omnitruck.chef.io/install.sh | sh -s -- -P inspec && \
    ## Install rubocop
    gem install rubocop:${RUBOCOP_VERSION} && \
    ## Install newer version of Rake
    gem install rake:13.0.3 && \
    ## Gem Cleanup
    gem cleanup webrick rake && \
    ## Install hadolint
    wget -O hadolint --progress=dot:giga https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 && \
    chmod +x hadolint && \
    ## Install cfn-guard
    wget --progress=dot:giga https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${CFN_GUARD_VERSION}/cfn-guard-v2-ubuntu-latest.tar.gz && \
    tar -xvf cfn-guard-v2-ubuntu-latest.tar.gz && \
    mv cfn-guard-v2-ubuntu-latest/cfn-guard . && \
    chmod +x cfn-guard && \
    rm -rf cfn-guard-v2-ubuntu-latest.tar.gz && \
    rm -rf cfn-guard-v2-ubuntu-latest && \
    ## Upgrade pip to avoid CVE's
    pip3 install --upgrade --no-cache-dir pip==21.1.1 && \
    ## Install cfn-lint
    pip install --no-cache-dir cfn-lint==${CFN_LINT_VERSION} && \
    ## Install checkov
    pip install --no-cache-dir checkov==${CHECKOV_VERSION} && \
    ## Install cfn-docs
    pip install --no-cache-dir cloudformation-docs==${CFN_DOCS_VERSION} && \
    ## Install yq
    pip install --no-cache-dir yq==${YQ_VERSION} && \
    ## Install reviewdog
    wget -O - -q --progress=dot:giga https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /bin/ v${REVIEWDOG_VERSION} && \
    ## Clean up
    yum clean all && \
    useradd -b /home -d /home/cfn_user cfn_user

USER cfn_user

WORKDIR /home/cfn_user

RUN mkdir cfn

COPY entrypoint.sh /home/cfn_user/entrypoint.sh

ENTRYPOINT ["/home/cfn_user/entrypoint.sh"]

HEALTHCHECK NONE