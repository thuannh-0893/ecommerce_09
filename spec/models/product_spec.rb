require "rails_helper"

RSpec.shared_examples "when empty" do |param1, param2|
  it param1+" should be present" do
    is_expected.to_not be_valid
  end

  it do
    product.save
    expect(product.errors.messages[param2].first).to eql I18n.t "errors.messages.blank"
  end
end

RSpec.shared_examples "when not a number" do |param1, param2|
  it param1+" should is a number" do
    is_expected.to_not be_valid
  end

  it do
    product.save
    expect(product.errors.messages[param2].first).to eql I18n.t "errors.messages.not_a_number"
  end
end

RSpec.describe Product, type: :model do
  let(:product) {FactoryBot.create :product}
  subject {product}

  it "should be valid" do
    expect(product).to be_valid
  end

  describe "#name" do
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_length_of(:name).is_at_most Settings.products.name_length}
    context "when name empty" do
      before {product.name = ""}

      it_behaves_like "when empty", "name", :name
    end

    context "when name too long" do
      before {product.name = "a" * (Settings.products.name_length + 1)}

      it "name should not be too long" do
        is_expected.to_not be_valid
      end

      it do
        product.save
        expect(product.errors.messages[:name]).equal?(I18n.t "errors.messages.too_long", count: Settings.products.name_length)
      end
    end
  end

  describe "#description" do
    it {is_expected.to validate_presence_of :description}

    context "when description empty" do
      before {product.description = ""}

      it_behaves_like "when empty", "description", :description
    end
  end

  describe "#price" do
    it {is_expected.to validate_presence_of :price}
    it {is_expected.to validate_numericality_of(:price)
      .is_greater_than_or_equal_to(Settings.products.zero)}

    context "when price empty" do
      before {product.price = ""}

      it_behaves_like "when empty", "price", :price
    end

    context "when price not a number" do
      before {product.price = "a"}

      it_behaves_like "when not a number", "price", :price
    end
  end

  describe "#quantity" do
    it {is_expected.to validate_presence_of :quantity}
    it {is_expected.to validate_numericality_of(:quantity)
      .is_greater_than_or_equal_to(Settings.products.zero).only_integer}

    context "when quantity empty" do
      before {product.quantity = ""}

      it_behaves_like "when empty", "quantity", :quantity
    end

    context "when quantity not a number" do
      before {product.quantity = "a"}

      it_behaves_like "when not a number", "quantity", :quantity
    end
  end

  describe "#rating" do
    it {is_expected.to validate_presence_of :rating}
    it {is_expected.to validate_numericality_of(:rating)
      .is_greater_than_or_equal_to(Settings.products.zero)
      .is_less_than_or_equal_to(Settings.products.max_rating)}

    context "when rating empty" do
      before {product.rating = ""}

      it_behaves_like "when empty", "rating", :rating
    end

    context "when rating not a number" do
      before {product.rating = "a"}

      it_behaves_like "when not a number", "rating", :rating
    end
  end

  describe "#views" do
    it {is_expected.to validate_presence_of :views}
    it {is_expected.to validate_numericality_of(:views)
      .is_greater_than_or_equal_to(Settings.products.zero).only_integer}

    context "when views empty" do
      before {product.views = ""}

      it_behaves_like "when empty", "views", :views
    end

    context "when views not a number" do
      before {product.views = "a"}

      it_behaves_like "when not a number", "views", :views
    end
  end

  describe "#discount" do
    it {is_expected.to validate_presence_of :discount}
    it {is_expected.to validate_numericality_of(:discount)
      .is_greater_than_or_equal_to(Settings.products.zero)
      .is_less_than_or_equal_to(Settings.products.max_discount)}

    context "when discount empty" do
      before {product.discount = ""}

      it_behaves_like "when empty", "discount", :discount
    end

    context "when discount not a number" do
      before {product.discount = "a"}

      it_behaves_like "when not a number", "discount", :discount
    end
  end

  describe ".associations" do
    it "should have many history views" do
      is_expected.to have_many(:history_views).dependent :destroy
    end

    it "should have many rates" do
      is_expected.to have_many(:rates).dependent :destroy
    end

    it "should have many products_orders" do
      is_expected.to have_many(:products_orders).dependent :destroy
    end

    it "should have many comments" do
      is_expected.to have_many(:comments).dependent :destroy
    end

    it "should have many item_photos" do
      is_expected.to have_many(:item_photos).dependent :destroy
    end
  end
end
