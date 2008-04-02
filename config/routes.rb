ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :photos, :categories
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => 'main', :action => 'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
