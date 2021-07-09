ARG BASE_IMAGE=htcondor/execute:el7
FROM ${BASE_IMAGE}
ARG BASE_IMAGE

LABEL org.opencontainers.image.title="HTCondor ATLAS AF Execute image derived from ${BASE_IMAGE}"

RUN yum install -y \
  @development \
  jq \ 
  zsh \
  git

# Remove the slot users because we want to put our UID domain everywhere.
RUN rm /etc/condor/config.d/01-slotusers.conf

#COPY condor/*.conf /etc/condor/config.d/

RUN mkdir /usr/local/etc/ciconnect

# Copy our script for HTCondor-ifying the values we get from the downward API
COPY pre-exec.sh /root/config/pre-exec.sh
