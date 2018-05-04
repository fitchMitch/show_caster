require 'rails_helper'

RSpec.describe "pictures/edit", type: :view do
  before(:each) do
    @picture = assign(:picture, Picture.create!(
      :fk => "MyString",
      :references => ""
    ))
  end

  it "renders the edit picture form" do
    render

    assert_select "form[action=?][method=?]", picture_path(@picture), "post" do

      assert_select "input#picture_fk[name=?]", "picture[fk]"

      assert_select "input#picture_references[name=?]", "picture[references]"
    end
  end
end
