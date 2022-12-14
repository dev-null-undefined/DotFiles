import re
import subprocess

enabled_by_default = True

priority = 500

regex = re.compile(r'\s([^\s]+): command not found')
nixregex = re.compile(r'nix-shell -p ([^\s]*)')


def match(command):
    return regex.findall(command.output)

def get_new_command(command):
    missing = regex.findall(command.output)[0]
    # TODO: implement for more then 1 missing package
    commands = []
    result = subprocess.run(['command-not-found', missing], capture_output=True, text=True)
    nixshellpkgs = nixregex.findall(result.stderr)
    for nixpkg in nixshellpkgs:
        commands.append(f'nix-pkg {nixpkg} -- {command.script}')
        commands.append(f'nix-pkg master.{nixpkg} -- {command.script}')
        commands.append(f'nix-pkg stable.{nixpkg} -- {command.script}')
    return commands
