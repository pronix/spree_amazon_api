Amazon::Ecs.class_eval do

  def self.browse_node_lookup(item_id, opts={})
    opts[:operation] = 'BrowseNodeLookup'

    # setting default option value
    opts[:browse_node_id] = item_id
    opts[:response_group] = opts[:response_group] || 'BrowseNodeInfo'
    self.send_request(opts)
  end

end
# BrowseNodeId=1065852BrowseNodeLookup
# Amazon::Ecs.browse_node_lookup(1065852, {:response_group => "BrowseNodes"})
# other_operation('[item_id]', :param1 => 'abc', :param2 => 'xyz')
