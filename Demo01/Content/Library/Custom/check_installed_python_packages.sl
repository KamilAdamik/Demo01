namespace: Custom
operation:
  name: check_installed_python_packages
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      import subprocess
      import sys

      def execute():
          out =  subprocess.run([sys.executable, "-m", "pip", "freeze"], capture_output=True)
          return {"installed_modules": out.stdout.decode()}
      # you can add additional helper methods below.
  outputs:
    - installed_modules
  results:
    - SUCCESS
