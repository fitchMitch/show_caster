require 'rails_helper'

RSpec.describe "pictures/new", type: :view do
  before(:each) do
    assign(:picture, Picture.new(
      :fk => "MyString",
      :references => ""
    ))
  end

  it "renders new picture form" do
    render

    assert_select "form[action=?][method=?]", pictures_path, "post" do

      assert_select "input#picture_fk[name=?]", "picture[fk]"

      assert_select "input#picture_references[name=?]", "picture[references]"
    end
  end
end
