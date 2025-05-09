{
  webdata = "/zroot/webdata";
  autheliaData = "/zroot/webdata/authelia";

  autheliaSysUser = "authelia";
  webdataSysGroup = "webdata";

  internalPorts = {
    ttyd = 1080;
    authelia = 2080;
  };
}
