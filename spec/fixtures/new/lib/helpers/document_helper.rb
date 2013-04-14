module DocumentHelper
  # All methods defined in this helper are avaiable in all templates.
  #
  # <%= foo %> # => "bar"
  #
  def foo
    "bar"
  end
end

Texas::Template.register_helper DocumentHelper
