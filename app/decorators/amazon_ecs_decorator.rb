Amazon::Ecs.class_eval do

  # BrowseNodeLookup
  # http://docs.amazonwebservices.com/AWSECommerceService/2010-11-01/DG/index.html?BrowseNodeLookup.html
  #
  # Books
  # Amazon::Ecs.browse_node_lookup(283155, {:response_group => "BrowseNodeInfo"})
  #
  #
  def self.browse_node_lookup(item_id, opts={})
    opts[:operation] = 'BrowseNodeLookup'
    opts[:browse_node_id] = item_id
    opts[:response_group] = opts[:response_group] || 'BrowseNodeInfo'
    self.send_request(opts)
  end

end
