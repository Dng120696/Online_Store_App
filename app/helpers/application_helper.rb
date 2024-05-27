module ApplicationHelper
    #For rendering the header when the user is in the login/registration page.
    def devise_controller?
        controller.class < DeviseController
      end
    
    def devise_page?
        devise_controller? && (action_name == 'new' || action_name == 'create')
    end
end
