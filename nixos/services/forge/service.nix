# Where the pipeline runs (ftl service metadata, not a module): the always-on
# box with the disk for the cache.
{
  hosts = [ "pavlov" ];

  # The cache it serves (fleet.cache on port 8080): every other host
  # substitutes from it, and the builder trusts its own key from here.
  cache = {
    publicKeys = [ "pavlov-1:6S3Kv1gWT/xoWcm0cRyz91M8JeGoD0oCD+T0SfamjVM=" ];
    port = 8080;
  };
}
