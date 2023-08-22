namespace: Custom
operation:
  name: install_a_python_package
  inputs:
    - packages_list
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(packages_list):\n    import subprocess\n    import sys\n    # leave empty string if you don't need a proxy\n    proxy = \"\"\n    # comma separated list of package names\n    packages = packages_list\n    for package in packages.split(\",\"):    \n        subprocess.run([sys.executable, \"-m\", \"pip\", \"--proxy\", proxy, \"install\", package])\n# you can add additional helper methods below."
  results:
    - SUCCESS
