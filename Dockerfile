FROM centos:7
RUN yum -y update
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python get-pip.py
RUN pip --help
RUN pip -V
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN pip install awsebcli --upgrade --user
ENV PATH="~/.local/bin:${PATH}"
RUN eb --version
COPY profile.sh /root/bin/
RUN ls /root/bin/