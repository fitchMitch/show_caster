require 'rails_helper'

RSpec.describe "theaters/index", type: :view do
  before do
    assign(:theaters, [
      Theater.create!(
        theater_name: "Theater Name",
        location: "Theater Address",
        manager: "Manager",
        manager_phone: "0123654789"
      ),
      Theater.create!(
        theater_name: "Theater Name",
        location: "Theater Address",
        manager: "Manager",
        manager_phone: "0123654789"
      )
      ])
  end

  let(:user) { create(:user,:admin) }

  it "renders a list of theaters" do
    enable_pundit(view, user)
    render
    assert_select "tr>td", text: /Theater Name/, count: 2
    assert_select "tr>td", text: /Theater Address/, count: 2
    assert_select "tr>td.manager", text: /Manager/, count: 2
    assert_select "tr>td", text: /01 23 65 47 89/, count: 2
  end
end
