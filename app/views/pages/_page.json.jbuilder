json.extract! page, :id, :url, :ipaddr, :source, :domain_whois, :ipaddr_whois, :created_at, :updated_at
json.url page_url(page, format: :json)
