module ApplicationHelper
  def default_meta_tags
    {
      site: 'pkgstatus.org',
      og: default_og,
    }
  end

  def default_og
    {
      title: 'pkgstatus.org',
      image: image_url('og-image.png'),
      url: request.original_url,
      description: 'Monitoring the health of packages',
    }
  end
end
