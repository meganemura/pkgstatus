module PackagesHelper
  def icon(package)
    case package.registry
    when 'rubygems'
      'far fa-gem'
    when 'npm'
      'fab fa-npm'
    else
      raise NotImplementedError
    end
  end
end
