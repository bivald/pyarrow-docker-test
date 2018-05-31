# pyarrow-docker-test
This Docker image builds pyarrow on top of pypy2 and runs the test suite (currently segfaulting). Please allow up to 30 minutes for the initial build. 



## Build image and run the test suite
`docker build -t pyarrow-test .`

## Entering with bash
When you've built the image, you can get into bash using:

`docker run --rm -it pyarrow-test /bin/bash`

And run the test suite with:

`cd /repos/arrow/python && /venv/bin/py.test pyarrow`

## Output:

```
======================================================================= test session starts =======================================================================
platform linux2 -- Python 2.7.13[pypy-6.0.0-final], pytest-3.6.0, py-1.5.3, pluggy-0.6.0
rootdir: /repos/arrow/python, inifile: setup.cfg
collected 843 items

pyarrow/tests/test_array.py .......F.F..F.....................Segmentation fault
```

## Test status:


**Tests**
Tests appears to give segfault with regards to dates. There are a few that fails as well, but mostly it appears to be pass or segfault (after installing the futures module for python2). Note that I'm running tests on python2, which may or may not effect results

- **pyarrow/tests/test_array.py** segfaults
    - test_cast_date32_to_int
- pyarrow/tests/test_builder.py passed
- **pyarrow/tests/test_convert_builtin.py** segfaults
    - test_limited_iterator_size_overflow
- **pyarrow/tests/test_convert_pandas.py** segfaults
    - test_datetime64_to_date32 
- pyarrow/tests/test_cython.py passes
- pyarrow/tests/test_deprecations.py no tests
- pyarrow/tests/test_feather.py passes
- pyarrow/tests/test_hdfs.py skipped
- pyarrow/tests/test_io.py a few fails (getrefcount, which is not to be implemented in pypy)
- pyarrow/tests/test_ipc.py passed
- pyarrow/tests/test_misc.py passed
- pyarrow/tests/test_parquet.py passed (1 fail)
- pyarrow/tests/test_plasma.py (I didn't build it)
- pyarrow/tests/test_scalars.py passes
- pyarrow/tests/test_schema.py passes
- **pyarrow/tests/test_serialization.py** segfaults
  - test_primitive_serialization
- pyarrow/tests/test_table.py passes
- pyarrow/tests/test_tensor.py passes, 1 fail (getrefcount, which is not to be implemented in pypy)
- pyarrow/tests/test_types.py passes

So most of them passes (and a few fails) but there are 4 segfaults:
- **pyarrow/tests/test_array.py** segfaults
    - test_cast_date32_to_int
- **pyarrow/tests/test_convert_builtin.py** segfaults
    - test_limited_iterator_size_overflow
- **pyarrow/tests/test_convert_pandas.py** segfaults
    - test_datetime64_to_date32 
- **pyarrow/tests/test_serialization.py** segfaults
  - test_primitive_serialization

They might have more then one test that segfaults, I just took the one that aborted the test (I didn't go in an manually exclude the segfaulting to see if there are more)

