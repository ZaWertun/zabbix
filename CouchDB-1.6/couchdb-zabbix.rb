#!/usr/bin/env ruby

require 'json'
require 'net/http'

# httpd_status_codes.201.{current|mean|min|max|sum|stddev}
# httpd_status_codes.200.{current|mean|min|max|sum|stddev}
# httpd_status_codes.202.{current|mean|min|max|sum|stddev}
# httpd_status_codes.412.{current|mean|min|max|sum|stddev}
# httpd_status_codes.301.{current|mean|min|max|sum|stddev}
# httpd_status_codes.304.{current|mean|min|max|sum|stddev}
# httpd_status_codes.405.{current|mean|min|max|sum|stddev}
# httpd_status_codes.404.{current|mean|min|max|sum|stddev}
# httpd_status_codes.403.{current|mean|min|max|sum|stddev}
# httpd_status_codes.500.{current|mean|min|max|sum|stddev}
# httpd_status_codes.401.{current|mean|min|max|sum|stddev}
# httpd_status_codes.400.{current|mean|min|max|sum|stddev}
# httpd_status_codes.409.{current|mean|min|max|sum|stddev}
# httpd.bulk_requests.{current|mean|min|max|sum|stddev}
# httpd.clients_requesting_changes.{current|mean|min|max|sum|stddev}
# httpd.requests.{current|mean|min|max|sum|stddev}
# httpd.view_reads.{current|mean|min|max|sum|stddev}
# httpd.temporary_view_reads.{current|mean|min|max|sum|stddev}
# httpd.aborted_requests.{current|mean|min|max|sum|stddev}
# couchdb.open_os_files.{current|mean|min|max|sum|stddev}
# couchdb.auth_cache_hits.{current|mean|min|max|sum|stddev}
# couchdb.database_reads.{current|mean|min|max|sum|stddev}
# couchdb.request_time.{current|mean|min|max|sum|stddev}
# couchdb.auth_cache_misses.{current|mean|min|max|sum|stddev}
# couchdb.database_writes.{current|mean|min|max|sum|stddev}
# couchdb.open_databases.{current|mean|min|max|sum|stddev}
# httpd_request_methods.HEAD.{current|mean|min|max|sum|stddev}
# httpd_request_methods.GET.{current|mean|min|max|sum|stddev}
# httpd_request_methods.PUT.{current|mean|min|max|sum|stddev}
# httpd_request_methods.POST.{current|mean|min|max|sum|stddev}
# httpd_request_methods.COPY.{current|mean|min|max|sum|stddev}
# httpd_request_methods.DELETE.{current|mean|min|max|sum|stddev}

def dot_path_get(hash, path)
    res = hash
    path.each do |p|
        if res.has_key?(p)
            res = res[p]
        else
            raise "Key not found"
        end
    end
    res
end

if ARGV.size < 1
    STDERR.puts "  Usage: #{$0} <CouchDB URL> [metric]"
    STDERR.puts "Example: #{$0} http://127.0.0.1:5984 couchdb.httpd.aborted_requests.value"
    exit 1
end

uri  = URI.parse("#{ARGV[0]}/_stats")
path = (ARGV[1] || '').split('.')

req  = Net::HTTP::Get.new(uri.to_s)
res  = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req)}
hash = JSON.parse(res.body)

if (value = dot_path_get(hash, path)).is_a?(Hash)
  puts JSON.pretty_generate(value)
else
  puts value || 0
end
