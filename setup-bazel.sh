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

if [ -x $(which bazel) ]; then
  echo "Bazel already installed. Skipping."
else
  if [[ -z "$V" ]]; then
    echo "::error::Missing bazel version"
  fi

  echo "::group::Install bazel from $URL"
  wget -O install.sh $URL
  chmod +x install.sh
  ./install.sh --user
  rm -f install.sh
  echo "::endgroup::"
fi
