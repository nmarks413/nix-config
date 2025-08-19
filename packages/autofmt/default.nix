{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "autofmt";
  runtimeInputs = with pkgs; [
    # include only a couple of formatters by default
    deno
    nixfmt-rfc-style
    dprint
    rustfmt
    zig
    clang-tools
  ];
  text = ''exec deno run -A ${./autofmt.js} "$@"'';
}
