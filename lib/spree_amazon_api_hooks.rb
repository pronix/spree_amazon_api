class SpreeAmazonApiHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  insert_after :admin_configurations_menu do
    %Q( <tr>
          <td><%= link_to t("amazon_settings"), admin_amazon_path %></td>
          <td><%= t("amazon_description") %></td>
        </tr>
       )
  end
end
