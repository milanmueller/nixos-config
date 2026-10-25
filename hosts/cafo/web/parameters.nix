{
  webdata = "/persist/webdata"; # must be on a persistent dataset, / is rolled back on boot
  webdataSysGroup = "webdata";
  internalPorts = {
    ttyd = 1080;
    authelia = 2080;
    mealie = 3080;
  };
}
