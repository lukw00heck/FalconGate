
##############################################
#                                            #
#        dnscrypt-proxy configuration        #
#                                            #
##############################################

## This is an example configuration file.
## You should adjust it to your needs, and save it as "dnscrypt-proxy.toml"
##
## Online documentation is available here: https://dnscrypt.info/doc



##################################
#         Global settings        #
##################################

## List of servers to use
## If this line is commented, all registered servers matching the require_* filters
## will be used
## The proxy will automatically pick the fastest, working servers from the list.
## Remove the leading # first to enable this; lines starting with # are ignored.

# server_names = ['scaleway-fr', 'google', 'yandex']


## List of local addresses and ports to listen to. Can be IPv4 and/or IPv6.
## To only use systemd activation sockets, use an empty set: []

listen_addresses = ['127.0.2.1:53']


## Maximum number of simultaneous client connections to accept

max_clients = 250


## Require servers (from static + remote sources) to satisfy specific properties

# Use servers reachable over IPv4
ipv4_servers = true

# Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
ipv6_servers = false

# Use servers implementing the DNSCrypt protocol
dnscrypt_servers = true

# Use servers implementing the DNS-over-HTTPS protocol
doh_servers = true


## Require servers defined by remote sources to satisfy specific properties

# Server must support DNS security extensions (DNSSEC)
require_dnssec = false

# Server must not log user queries (declarative)
require_nolog = true

# Server must not enforce its own blacklist (for parental control, ads blocking...)
require_nofilter = true



## Always use TCP to connect to upstream servers

force_tcp = false


## How long a DNS query will wait for a response, in milliseconds

timeout = 2500


## Load-balancing strategy: 'p2' (default), 'ph', 'fastest' or 'random'

# lb_strategy = 'p2'


## Log level (0-6, default: 2 - 0 is very verbose, 6 only contains fatal errors)

# log_level = 2


## log file for the application

# log_file = 'dnscrypt-proxy.log'


## Use the system logger (syslog on Unix, Event Log on Windows)

# use_syslog = true


## Delay, in minutes, after which certificates are reloaded

cert_refresh_delay = 240


## Fallback resolver
## This is a normal, non-encrypted DNS resolver, that will be only used
## for one-shot queries when retrieving the initial resolvers list, and
## only if the system DNS configuration doesn't work.
## No user application queries will ever be leaked through this resolver,
## and it will not be used after IP addresses of resolvers URLs have been found.
## It will never be used if lists have already been cached, and if stamps
## don't include host names without IP addresses.
## It will not be used if the configured system DNS works.
## A resolver supporting DNSSEC is recommended. This may become mandatory.

fallback_resolver = '8.8.8.8:53'


## Never try to use the system DNS settings; unconditionally use the
## fallback resolver.

ignore_system_dns = false



#########################
#        Filters        #
#########################

## Immediately respond to IPv6-related queries with an empty response
## This makes things faster when there is no IPv6 connectivity, but can
## also cause reliability issues with some stub resolvers. In
## particular, enabling this on macOS is not recommended.

block_ipv6 = false



##################################################################################
#        Route queries for specific domains to a dedicated set of servers        #
##################################################################################

## Example map entries (one entry per line):
## example.com 9.9.9.9
## example.net 9.9.9.9,8.8.8.8

# forwarding_rules = 'forwarding-rules.txt'



###############################
#        Cloaking rules       #
###############################

## Cloaking returns a predefined address for a specific name.
## In addition to acting as a HOSTS file, it can also return the IP address
## of a different name. It will also do CNAME flattening.
##
## Example map entries (one entry per line)
## example.com     10.1.1.1
## www.google.com  forcesafesearch.google.com

# cloaking_rules = 'cloaking-rules.txt'



###########################
#        DNS cache        #
###########################

## Enable a DNS cache to reduce latency and outgoing traffic

cache = true


## Cache size

cache_size = 256


## Minimum TTL for cached entries

cache_min_ttl = 600


## Maxmimum TTL for cached entries

cache_max_ttl = 86400


## TTL for negatively cached entries

cache_neg_ttl = 60



###############################
#        Query logging        #
###############################

## Log client queries to a file

[query_log]

  ## Path to the query log file (absolute, or relative to the same directory as the executable file)

  # file = 'query.log'


  ## Query log format (currently supported: tsv and ltsv)

  format = 'tsv'


  ## Do not log these query types, to reduce verbosity. Keep empty to log everything.

  # ignored_qtypes = ['DNSKEY', 'NS']



############################################
#        Suspicious queries logging        #
############################################

## Log queries for nonexistent zones
## These queries can reveal the presence of malware, broken/obsolete applications,
## and devices signaling their presence to 3rd parties.

[nx_log]

  ## Path to the query log file (absolute, or relative to the same directory as the executable file)

  # file = 'nx.log'


  ## Query log format (currently supported: tsv and ltsv)

  format = 'tsv'



######################################################
#        Pattern-based blocking (blacklists)        #
######################################################

## Blacklists are made of one pattern per line. Example of valid patterns:
##
##   example.com
##   *sex*
##   ads.*
##   ads*.example.*
##   ads*.example[0-9]*.com
##
## Example blacklist files can be found at https://download.dnscrypt.info/blacklists/
## A script to build blacklists from public feeds can be found in the
## `utils/generate-domains-blacklists` directory of the dnscrypt-proxy source code.

[blacklist]

  ## Path to the file of blocking rules (absolute, or relative to the same directory as the executable file)

  # blacklist_file = 'blacklist.txt'


  ## Optional path to a file logging blocked queries

  # log_file = 'blocked.log'


  ## Optional log format: tsv or ltsv (default: tsv)

  # log_format = 'tsv'



###########################################################
#        Pattern-based IP blocking (IP blacklists)        #
###########################################################

## IP blacklists are made of one pattern per line. Example of valid patterns:
##
##   127.*
##   fe80:abcd:*
##   192.168.1.4

[ip_blacklist]

  ## Path to the file of blocking rules (absolute, or relative to the same directory as the executable file)

  # blacklist_file = 'ip-blacklist.txt'


  ## Optional path to a file logging blocked queries

  # log_file = 'ip-blocked.log'


  ## Optional log format: tsv or ltsv (default: tsv)

  # log_format = 'tsv'



##########################################
#        Time access restrictions        #
##########################################

## One or more weekly schedules can be defined here.
## Patterns in the name-based blocklist can optionally be followed with @schedule_name
## to apply the pattern 'schedule_name' only when it matches a time range of that schedule.
##
## For example, the following rule in a blacklist file:
## *.youtube.* @time-to-sleep
## would block access to Youtube only during the days, and period of the days
## define by the 'time-to-sleep' schedule.
##
## {after='21:00', before= '7:00'} matches 0:00-7:00 and 21:00-0:00
## {after= '9:00', before='18:00'} matches 9:00-18:00

[schedules]

  # [schedules.'time-to-sleep']
  # mon = [{after='21:00', before='7:00'}]
  # tue = [{after='21:00', before='7:00'}]
  # wed = [{after='21:00', before='7:00'}]
  # thu = [{after='21:00', before='7:00'}]
  # fri = [{after='23:00', before='7:00'}]
  # sat = [{after='23:00', before='7:00'}]
  # sun = [{after='21:00', before='7:00'}]

  # [schedules.'work']
  # mon = [{after='9:00', before='18:00'}]
  # tue = [{after='9:00', before='18:00'}]
  # wed = [{after='9:00', before='18:00'}]
  # thu = [{after='9:00', before='18:00'}]
  # fri = [{after='9:00', before='17:00'}]



#########################
#        Servers        #
#########################

## Remote lists of available servers
## Multiple sources can be used simultaneously, but every source
## requires a dedicated cache file.
##
## Refer to the documentation for URLs of public sources.
##
## A prefix can be prepended to server names in order to
## avoid collisions if different sources share the same for
## different servers. In that case, names listed in `server_names`
## must include the prefixes.

[sources]

  ## An example of a remote source

  [sources.'public-resolvers']
  url = 'https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md'
  cache_file = 'public-resolvers.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  refresh_delay = 72
  prefix = ''

  ## Another example source, with resolvers censoring some websites not approriate for children
  ## This is a subset of the `public-resolvers` list, so enabling both is useless

  #  [sources.'parental-control']
  #  url = 'https://download.dnscrypt.info/resolvers-list/v2/parental-control.md'
  #  cache_file = 'parental-control.md'
  #  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'



## Optional, local, static list of additional servers
## Mostly useful for testing your own servers.

[static]

  # [static.'google']
  # stamp = 'sdns://AgUAAAAAAAAAACDyXGrcc5eNecJ8nomJCJ-q6eCLTEn6bHic0hWGUwYQaA5kbnMuZ29vZ2xlLmNvbQ0vZXhwZXJpbWVudGFs'
