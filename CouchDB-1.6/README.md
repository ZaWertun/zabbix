
About
======
Zabbix monitoring for CouchDB-1.6.
CouchDB version 1.7 should also be supported, but not tested yet.
Script and template was based on https://gist.github.com/crashdump/7769658.

Prerequisites
======

You need ruby version `2.0` or newer to execute `couchdb-zabbix.rb`.

Installation
======
1. Create file `/etc/zabbix/zabbix_agentd.d/userparameter_couchdb.conf`
with following content:

        UserParameter=couchdb[*], /usr/local/bin/couchdb-zabbix.rb $1 $2

2. Copy supplied script `couchdb-zabbix.rb` to directory `/usr/local/bin` and check that it can be executed:

    ```shell
    $ ls -la /usr/local/bin
    -rwxr-xr-x 1 root root 2596 Mar 29 19:38 /usr/local/bin/couchdb-zabbix.rb
    ```

2. Restart zabbix-agent:

        systemctl restart zabbix-agent

3. Import template `Template CouchDB.xml` to Zabbix.

4. Assign template to host and define macros `{$COUCHDB_URL}` if needed.
Default macros values is `http://127.0.0.1:5984`.

Testing
======
You can test provided script with following command:
```shell
$ /usr/local/bin/couchdb-zabbix.rb http://127.0.0.1:5984 couchdb.open_os_files
{
  "description": "number of file descriptors CouchDB has open",
  "current": 50.0,
  "sum": 50.0,
  "mean": 0.001,
  "stddev": 0.131,
  "min": -2,
  "max": 27
}
```

List of all supported metrics can be found in `couchdb-zabbix.rb`.
Or you can run script without last parameter, it will output all values.
```shell
$ /usr/local/bin/couchdb-zabbix.rb http://127.0.0.1:5984
{
  "auth_cache_misses": {
    "description": "number of authentication cache misses",
    "current": null,
    "sum": null,
    "mean": null,
    "stddev": null,
    "min": null,
    "max": null
  },
  ...
}
```
