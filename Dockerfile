FROM pypy:2

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            lsb-release \
            git-core \
            pkg-config \
            libjemalloc-dev \
            libboost-dev \
           libboost-filesystem-dev \
           libboost-system-dev \
           libboost-regex-dev \
           flex \
           bison \
           wget

RUN cd /root/ && wget http://www.cmake.org/files/v3.7/cmake-3.7.1.tar.gz && cd /root/ && tar xzf cmake-3.7.1.tar.gz && cd /root/cmake-3.7.1/ && ./configure && make && make install
RUN mkdir -p /repos/dist && git clone https://github.com/apache/arrow.git /repos/arrow && git clone https://github.com/apache/parquet-cpp.git /repos/parquet-cpp
RUN /usr/local/bin/pypy -m pip install virtualenv && virtualenv -p /usr/local/bin/pypy /venv/ && /venv/bin/pip install six numpy pytest pandas cython
RUN cd /repos/arrow/cpp/ && ARROW_BUILD_TYPE=release ARROW_HOME=/repos/dist PARQUET_HOME=/repos/dist LD_LIBRARY_PATH=/repos/dist/lib:$LD_LIBRARY_PATH cmake \
        -DCMAKE_BUILD_TYPE=release \
        -DCMAKE_INSTALL_PREFIX=/repos/dist \
        -DARROW_PYTHON=on \
        -DARROW_BUILD_TESTS=OFF \
        -DPYTHON_EXECUTABLE=/venv/bin/pypy && make -j4 && make install
RUN cd /repos/parquet-cpp/ && ARROW_BUILD_TYPE=release ARROW_HOME=/repos/dist PARQUET_HOME=/repos/dist LD_LIBRARY_PATH=/repos/dist/lib:$LD_LIBRARY_PATH cmake \
        -DCMAKE_BUILD_TYPE=release \
        -DCMAKE_INSTALL_PREFIX=/repos/dist \
        -DARROW_PYTHON=on \
        -DARROW_BUILD_TESTS=OFF \
        -DPYTHON_EXECUTABLE=/venv/bin/pypy && make -j4 && make install
RUN cd /repos/arrow/python/ && ARROW_BUILD_TYPE=release ARROW_HOME=/repos/dist PARQUET_HOME=/repos/dist LD_LIBRARY_PATH=/repos/dist/lib:$LD_LIBRARY_PATH  /venv/bin/pypy setup.py build_ext --build-type=release \
       --with-parquet  --bundle-arrow-cpp --inplace

RUN cd /repos/arrow/python && ! /venv/bin/py.test pyarrow
