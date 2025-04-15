{ lib, ... }:
{
  options.custom = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Primary username";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "Home directory";
      };
    };
    system = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "System hostname";
      };
    };
  };
}
