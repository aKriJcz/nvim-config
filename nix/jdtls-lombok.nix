# jdtls with the Lombok agent, used by ftplugin/java.lua (and Claude Code's LSP plugin).
{ writeShellScriptBin, jdt-language-server, lombok }:
writeShellScriptBin "jdtls-lombok" ''
  exec ${jdt-language-server}/bin/jdtls \
    --jvm-arg=-javaagent:${lombok}/share/java/lombok.jar \
    "$@"
''
