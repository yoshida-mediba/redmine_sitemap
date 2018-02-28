class SitemapController < ApplicationController
  unloadable

  def xml
    render :layout => false, :content_type => 'application/xml'
  end
end
