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
