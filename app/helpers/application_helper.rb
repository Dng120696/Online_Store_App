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

        case current_hour.hour
        when 6..11
          "Morning"
        when 12..17
          "Afternoon"
        when 18..21
          "Evening"
        else
          "Night"
        end
      end
end
