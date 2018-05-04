require 'rails_helper'

RSpec.describe "pictures/index", type: :view do
  before(:each) do
    assign(:pictures, [
      Picture.create!(
        :fk => "Fk",
        :references => ""
      ),
      Picture.create!(
        :fk => "Fk",
        :references => ""
      )
    ])
  end

  it "renders a list of pictures" do
    render
    assert_select "tr>td", :text => "Fk".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
