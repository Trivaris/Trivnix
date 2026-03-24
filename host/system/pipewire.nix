{
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
  "context.properties" = {
    "default.clock.rate" = 48000;
    "default.clock.quantum" = 1024;
    "default.clock.min-quantum" = 32;
    "default.clock.max-quantum" = 2048;
  };
};
}