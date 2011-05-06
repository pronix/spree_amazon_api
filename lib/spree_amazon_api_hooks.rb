class SpreeAmazonApiHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  insert_after :admin_configurations_menu do
    %Q( <tr>
          <td><%= link_to t("amazon_settings"), admin_amazon_path %></td>
          <td><%= t("amazon_description") %></td>
        </tr>
       )
  end

  replace :cart_form do
    %Q( <div id="cart-form">
        <% if !!Spree::Config[:redirect_to_amazon] %>
          <%= render 'shared/amazon_cart_form' %>
        <% else %>
          <%= render 'cart_form' %>
        <% end %>
        </div>
      )
  end

end
