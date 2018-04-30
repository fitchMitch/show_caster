require 'rails_helper'

RSpec.describe "theaters/show", type: :view do
  before(:each) do
    @theater = assign(:theater, Theater.create!(
      :theater_name => "Theater Name",
      :location => "Theater Address",
      :manager => "Manager",
      :manager_phone => "012365214582"
    ))
  end

  it "renders attributes in <p>" do

    render
    # byebug
    expect(rendered).to match(/Theater Name/)
    expect(rendered).to match(/Theater Address/)
    expect(rendered).to match(/Manager/)
    expect(rendered).to match(/01 23 65 21 4582/)
  end
end
