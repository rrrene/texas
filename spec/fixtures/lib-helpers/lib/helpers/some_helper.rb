module SomeHelper
  def some_value
    document.some_value
  end
end

Template.register_helper SomeHelper
