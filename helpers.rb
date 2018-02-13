helpers do
  # Construct a link to +url_fragment+, which should be given relative to
  # the base of this Sinatra app.  The mode should be either
  # <code>:path_only</code>, which will generate an absolute path within
  # the current domain (the default), or <code>:full_url</code>, which will
  # include the site name and port number.  The latter is typically necessary
  # for links in RSS feeds.  Example usage:
  #
  #   link_to "/foo" # Returns "http://example.com/myapp/foo"
  #
  #--
  # Thanks to cypher23 on #mephisto and the folks on #rack for pointing me
  # in the right direction.
  #
  # Thanks to emk for this url_for segment.
  # I'm making link_to act a little more like rails link_to, but the url_for
  # which is emk's link_to works great for not creating the <a> tags.
  def url_for url_fragment, mode=:path_only
    case mode
    when :path_only
      base = request.script_name
    when :full_url
      if (request.scheme == 'http' && request.port == 80 ||
          request.scheme == 'https' && request.port == 443)
        port = ""
      else
        port = ":#{request.port}"
      end
      base = "#{request.scheme}://#{request.host}#{port}#{request.script_name}"
    else
      raise "Unknown script_url mode #{mode}"
    end
    "#{base}#{url_fragment}"
  end

  def link_to link_text, url, mode=:path_only
  # You should add "!!" at the beginning if you're directing at the Sinatra url
    if(url_for(url,mode)[0,2] == "!!")
      trimmed_url = url_for(url,mode)[2..-1]
      "<a href=#{trimmed_url}> #{link_text}</a>"
    else
      "<a href=#{url_for(url,mode)}> #{link_text}</a>"
    end  
  end
end