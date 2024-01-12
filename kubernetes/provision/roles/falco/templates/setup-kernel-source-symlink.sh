debian_kernel_version=$(uname -r)
debian_kernel_arch=$(uname -r | cut -d'-' -f3)
linux_kernel_version=$(uname -v | cut -d' ' -f4)
src="/lib/modules/${debian_kernel_version}"
link="/lib/modules/${linux_kernel_version}-${debian_kernel_arch}"

if [ ! -L ${link} ]; then
  ln -sf ${src} ${link}
  echo "Created kernel source link"
fi
