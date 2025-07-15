# master

# 2.20.0 (2025-07-15)
  * Sync with https://github.com/ua-parser/uap-core/commit/432e95f6767cc8bab4c20c255784cd6f7e93bc15
  * drop Ruby 3.0 support
  * Add Ruby 3.4 support

# 2.19.0 (2024-12-10)
  * Sync with https://github.com/ua-parser/uap-core/commit/d4cde4c565a7e588472fbf6667f01fc4c23fa60b

# 2.18.0 (2024-06-04)
  * Sync with https://github.com/ua-parser/uap-core/commit/df56280c9e2b42dd64be2b750f803c58feb3f94a

# 2.17.0 (2024-02-23)
  * Sync with https://github.com/ua-parser/uap-core/commit/d3450bbe77fe49eb3a234ed6184065260e44d747

# 2.16.0 (2023-06-07)
  * Sync with https://github.com/ua-parser/uap-core/tree/v0.18.0

# 2.15.0 (2023-04-12)
 * Expose `parse_os`, `parse_device` and `parse_ua` methods on `Parser`

# 2.14.0 (2023-01-31)
  * Sync with https://github.com/ua-parser/uap-core/commit/1ef0926f2b489cc929589c00f8b8a3efce25acc3

# 2.13.0 (2022-10-21)
  * Support loading multiple database files (via #70) (@misdoro)
    * Support `patterns_path` argument but deprecate `pattern_path` attribute accessor
      in `UserAgentParser::Parser`
    * Add new `patterns_paths` array argument `UserAgentParser::Parser` to enable loading
      multiple patterns files

# 2.12.0 (2022-10-20)

  * sync with https://github.com/ua-parser/uap-core/commit/dc85ab2628798538a2874dea4a9563f40a31f55a
  * Memory optimization (via #104) (@casperisfine)

# 2.11.0 (2022-04-18)
  * Make user agent versions comparable (via #68) (@misdoro)

# 2.10.0 (2022-04-18)
  * sync with uap-core 09e9ccc

# 2.9.0 (2022-01-27)
  * sync with uap-core 0.15.0

# 2.8.0 (2021-11-02)
  * sync with uap-core 0.14.0
  * drop support for ruby 2.4

# 2.7.0 (2020-05-25)
  * sync with uap-core 0.10.0
