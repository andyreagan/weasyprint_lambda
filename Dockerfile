FROM public.ecr.aws/sam/build-python3.9
ARG DEBIAN_FRONTEND=noninteractive
RUN yum update -y

# Based on https://aws.amazon.com/premiumsupport/knowledge-center/lambda-linux-binary-package/
RUN yum install -y yum-utils rpmdevtools
WORKDIR /tmp
RUN yumdownloader libffi libffi-devel cairo pango && rpmdev-extract *rpm

RUN mkdir /opt/python
WORKDIR /opt
RUN cp -P -R /tmp/*/usr/lib64/* /opt/python
RUN ln python/libpango-1.0.so.0 python/pango-1.0.0 && ln python/libpangocairo-1.0.so.0 python/pangocairo-1.0
RUN zip weasyprint_lambda_layer.zip python/*
