require "spec_helper"

RSpec.describe "admin/products/new.html.erb", type: :view do
  let(:admin_product) {Product.new}
  let(:category) {Category.sub_only.by_name}
  subject {rendered}

  before do
    assign :admin_product, admin_product
    assign :sub_categories, category
    render
  end

  it {is_expected.to have_content "Add new product"}

  describe "form" do
    it {assert_select "form[action*=?]", admin_products_path}

    it {is_expected.to have_field "product_name"}

    it {is_expected.to have_field "product_category_id"}

    it {is_expected.to have_field "product_price"}

    it {is_expected.to have_field "product_discount"}

    it {is_expected.to have_field "product_quantity"}

    it {is_expected.to have_field "product_description"}

    it {is_expected.to have_selector "input", class: "btn btn-primary"}

    it {is_expected.to render_template(partial: "_form")}
  end
end
