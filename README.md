## setup bazel action

GitHub action to setup bazel.

#### Usage

**Note**: Make sure the runner or container image you use the action with has at least `wget`/`curl`, `unzip` and a java jdk installed.

```yaml
# .github/workflows/ci.yml
name: CI
on: ['push']

jobs:
  build:
    runs-on: 'ubuntu-latest'
    steps:
    - uses: actions/checkout@v2

    - name: 'setup bazel'
      uses: 'romnnn/setup-bazel-action@master'
      # optionally:
      with:
        version: 3.7.1

    - name: 'run a bazel command'
      run: |
        bazel -h
```
