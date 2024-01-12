"""Extra Ansible filters"""

import os


def linux_kernel_version(current_version):
    """
    Get linux kernel version.

    Args:
        current_version (str): This parameter is a placeholder.
        Current kernel version in Debian ABI compatible
        version scheme.

    Returns:
        str: Debian kernel version string.
    """
    return os.uname().version.split(' ')[3]

class FilterModule(object):
    """Return filter plugin"""

    @staticmethod
    def filters():
        """Return filter"""
        return {
            "linux_kernel_version": linux_kernel_version,
        }
