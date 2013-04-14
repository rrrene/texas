module DocumentHelper
  def some_value
    document.some_value
  end
end

Texas::Template.register_helper DocumentHelper
