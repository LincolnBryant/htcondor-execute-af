ARG BASE_IMAGE=htcondor/execute:el7
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
ARG PACKAGE_LIST=packagelist-el7.txt

LABEL org.opencontainers.image.title="HTCondor ATLAS AF Execute image derived from ${BASE_IMAGE}"

COPY $PACKAGE_LIST /root/extra-packagelist.txt
COPY container-install-execute.sh /root/container-install-execute.sh
RUN bash -x /root/container-install-execute.sh /root/extra-packagelist.txt

# Remove the slot users because we want to put our UID domain everywhere.
RUN rm /etc/condor/config.d/01-slotusers.conf

#COPY condor/*.conf /etc/condor/config.d/

# Copy our script for HTCondor-ifying the values we get from the downward API
COPY pre-exec.sh /root/config/pre-exec.sh
