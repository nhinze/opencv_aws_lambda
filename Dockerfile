FROM amazonlinux

RUN yum update -y
RUN yum install gcc openssl-devel bzip2-devel libffi-devel wget tar gzip zip make zlib-devel -y

# Install Python 3.13
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.13.3/Python-3.13.3.tgz
RUN tar -xzvf Python-3.13.3.tgz
WORKDIR /Python-3.13.3
RUN ./configure --enable-optimizations
RUN make altinstall

# Install Python packages
RUN mkdir /packages
RUN echo "opencv-python-headless" >> /packages/requirements.txt
RUN mkdir -p /packages/opencv-python-headless-3.13/python/lib/python3.13/site-packages
RUN pip3.13 install -r /packages/requirements.txt -t /packages/opencv-python-headless-3.13/python/lib/python3.13/site-packages

# Create zip files for Lambda Layer deployment
WORKDIR /packages/opencv-python-headless-3.13/
RUN zip -r9 /packages/cv2-python313.zip .
WORKDIR /packages/
RUN rm -rf /packages/opencv-python-headless-3.13/

