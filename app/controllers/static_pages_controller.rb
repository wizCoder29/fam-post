class StaticPagesController < ApplicationController

 #Adding a feed instance variable to the home action.
  def home
    #binding.pry
    @user = current_user
    @categories_select = ["APPETIZER", "BREAKFAST", "LUNCH", "DINNER", "DESSERT", "BEVERAGE", "SPECIAL OF THE DAY", "SIDE"]
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

      @microposts = @user.microposts.paginate(page: params[:page])
      @categories = []

      _set_up_categories(@user.microposts)

      @user.microposts.each do |micropost|
        if micropost.category.present?
          @categories.push(micropost) unless @categories.map(&:category).include?(micropost.category)
        end
      end
    end

  end

  def contact_us
    begin
      UserMailer.say_hello(params).deliver_later
      flash[:info] = "Message sent successfully."
      redirect_to root_url
    rescue Exception => e
      raise e
    end
  end

  def index
    render :template => 'static_pages/home'
  end

  def help
  end

  def about
  end

  def contact
  end

  private

   def _set_up_categories(items)
     @appetizer_cat = items.select {|mic| mic.category == "APPETIZER" } || []
     @breakfast_cat = items.select {|mic| mic.category  == "BREAKFAST" } || []
     @lunch_cat = items.select {|mic| mic.category  == "LUNCH" } || []
     @dinner_cat = items.select {|mic| mic.category == "DINNER" } || []
     @dessert_cat = items.select {|mic| mic.category  == "DESSERT" } || []
     @beverage_cat = items.select {|mic| mic.category  == "BEVERAGE" } || []
     @special_of_day_cat = items.select {|mic| mic.category  == "SPECIAL OF THE DAY" } || []
     @side_cat = items.select {|mic| mic.category  == "SIDE" } || []
   end
end
