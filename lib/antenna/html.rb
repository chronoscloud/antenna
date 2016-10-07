require 'erb'

module Antenna
  class HTML
    include ERB::Util
  
    attr_accessor :info_plist, :manifest_url, :display_image_url, :need_shine

    def initialize(info_plist, manifest_url, display_image_url)
        @info_plist, @manifest_url, @display_image_url = info_plist, manifest_url, display_image_url
    end

    def template
      <<-EOF
<!doctype html>
<html>
<head>
    <title><%= @info_plist.bundle_display_name %> v<%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <style type="text/css">
        body {
          text-align: center;
	  			font-family: 'Open Sans', sans-serif;
	  			font-size: 14px;
	  			line-height: 28px;
	  			background-color: #fff;
	  		}
        img { display: block; margin: 1em auto; border: none; width: 120px; height: 120px; border-radius: 20px; }
        .btn, a.btn, a.btn:visited, a.btn:hover, a.btn:link { 
            display: inline-block;
            border-radius: 3px;
            background-color: #ff9900;
            color: white;
            padding: .8em 1em;
            text-decoration: none;
            font-weight: normal;
				    text-transform: uppercase;
				    letter-spacing: 1px;
        }
        .comment {
            color: #999
        }
        h1, h2, h3, h4, h5, h6 {
          font-family: "Raleway", sans-serif;
          letter-spacing: 1px;
          margin-top: 15px;
          font-weight: normal;
			  }
    </style>
</head>
<body>
    <h1><%= @info_plist.bundle_display_name %></h1>
    <h2><%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</h2>
    <% if @display_image_url %>
    <a href="itms-services://?action=download-manifest&amp;url=<%= u(@manifest_url) %>">
        <img src="<%= @display_image_url %>">
    </a>
    <% end %>
    <p><strong>Download the latest build of <%= @info_plist.bundle_display_name %> v<%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</strong> by tapping the button below on your mobile device.</p>
    <a href="itms-services://?action=download-manifest&amp;url=<%= u(@manifest_url) %>" class="btn">Tap to install</a>
    <% if @info_plist.bundle_minimum_os_version %>
    <p class="comment">
        This app requires iOS <%= @info_plist.bundle_minimum_os_version %> or higher.
    </p>
    <% end %>
</body>
</html>
EOF
    end

    def to_s
      ERB.new(template).result(binding)
    end
  end
end