#!/bin/bash

V=$1
OS=linux
ARCH=x86_64
if [[ "$OSTYPE" == "darwin"* ]]; then OS=darwin; fi

GH_BASE="https://github.com/bazelbuild/bazel/releases/download/$V"
GH_ARTIFACT="bazel-$V-installer-$OS-$ARCH.sh"
CI_BASE="http://ci.bazel.io/job/Bazel/JAVA_VERSION=1.8,PLATFORM_NAME=$OS-$ARCH/lastSuccessfulBuild/artifact/output/ci"
CI_ARTIFACT="bazel--installer.sh"

URL="$GH_BASE/$GH_ARTIFACT"
if [[ "$V" == "HEAD" ]]; then CI_ARTIFACT="$(wget -qO- $CI_BASE | grep -o 'bazel-[-_a-zA-Z0-9\.]*-installer.sh' | uniq)"; fi
if [[ "$V" == "HEAD" ]]; then URL="$CI_BASE/$CI_ARTIFACT"; fi

if [[ -z "$V" ]]; then
  echo "::error::Missing bazel version"
  exit 1
fi

if which bazel > /dev/null; then
  INSTALLED_V=$(bazel --version | sed 's/bazel //')
  echo "Note: bazel $INSTALLED_V already installed."

  if [[ "$INSTALLED_V" == "$V" ]]; then
    echo "Skipping installation."
    exit 0
  else
    echo "::warning::Bazel $INSTALLED_V already installed, attempting to install bazel $V..."
  fi
fi

echo "::group::Install bazel from $URL"
if which wget > /dev/null; then
  wget --quiet -O install.sh $URL > /dev/null
else
  curl -L --silent --output install.sh $URL > /dev/null
fi
chmod +x install.sh
./install.sh --user
rm -f install.sh
echo "Adding $HOME/bin to $GITHUB_PATH"
echo "$HOME/bin" >> "$GITHUB_PATH"
echo "::endgroup::"
