#!/bin/bash

set -euo pipefail

container=$1
environment=$2

case $environment in
  xfce)
    environment=xfce-desktop-environment
    ;;
  gnome)
    environment=workstation-product-environment
    ;;
  *)
    echo "Unknown environment"
    exit 1
    ;;
esac

# Get required groups for the requested environment
groups=$(podman run --rm "$container" bash -c "dnf environment info $environment 2> /dev/null" | awk '/Required groups/{flag=1} /Optional groups/{flag=0} flag {sub(/^.*: */, ""); print}')

groups_num=$(echo "${groups}" | wc -w)

index=1
for group in $groups
do
  echo "Add group $index of ${groups_num}"
  if [[ $index -eq 1 ]]
  then
    echo "FROM ${container} AS group1" > Containerfile
    
    # Install audit separately because the post-install script requires systemd.
    # It only starts the audit service, so it is not required.
    echo "RUN dnf install audit -y --setopt=tsflags=noscripts" >> Containerfile
    
    # Create alternatives directory
    echo "RUN mkdir /var/lib/alternatives" >> Containerfile
  else
    if [[ $index -eq "${groups_num}" ]]
    then
      echo "FROM group$((index - 1)) as workstation" >> Containerfile
    else
      echo "FROM group$((index - 1)) as group${index}" >> Containerfile
    fi
  fi
  cat << EOF >> Containerfile
RUN mkdir /var/roothome

RUN dnf group install -y "${group}" && \
    dnf clean all && \
    rm -Rf /var/roothome

EOF
  index=$((index + 1))
done

cat "Containerfile.${2}" >> Containerfile
