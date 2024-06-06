module ApplicationHelper
    #For rendering the header when the user is in the login/registration page.
    def devise_controller?
        controller.class < DeviseController
      end

    def devise_page?
        devise_controller? && (action_name == 'new' || action_name == 'create')
    end
    def greeting
        current_hour = Time.zone.now + 8.hours
        p current_hour.hour
        case current_hour.hour
        when 0..12
          "Morning"
        when 12..18
          "Afternoon"
        else
          "Evening"
        end
      end
end
