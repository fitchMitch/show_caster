require 'rails_helper'

RSpec.describe "theaters/edit", type: :view do
  before(:each) do
    @theater = assign(:theater, create(:theater))
  end

  it "renders the edit theater form" do
    render

    assert_select "form[action=?][method=?]", theater_path(@theater), "post" do
      assert_select "input#theater_theater_name[name=?]", "theater[theater_name]"
      assert_select "input#theater_location[name=?]", "theater[location]"
      assert_select "input#theater_manager[name=?]", "theater[manager]"
      assert_select "input#theater_manager_phone[name=?]", "theater[manager_phone]"
    end
  end
end
