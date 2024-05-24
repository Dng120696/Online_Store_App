class Owner::CategoriesController < ApplicationController
  before_action :authenticate_admin!
end
