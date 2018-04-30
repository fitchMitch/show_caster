require 'rails_helper'

RSpec.describe "theaters/new", type: :view do
  before(:each) do
    assign(:theater, Theater.new(
      :theater_name => "MyString",
      :location => "MyString",
      :manager => "MyString",
      :manager_phone => "MyString"
    ))
  end

  it "renders new theater form" do
    render

    assert_select "form[action=?][method=?]", theaters_path, "post" do

      assert_select "input#theater_theater_name[name=?]", "theater[theater_name]"

      assert_select "input#theater_location[name=?]", "theater[location]"

      assert_select "input#theater_manager[name=?]", "theater[manager]"

      assert_select "input#theater_manager_phone[name=?]", "theater[manager_phone]"
    end
  end
end
