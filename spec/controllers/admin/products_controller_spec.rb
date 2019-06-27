# require "rails_helper"

# RSpec.describe Admin::ProductsController, type: :controller do
#   let(:product) {FactoryBot.create :product}
#   let(:admin){FactoryBot.create :admin}
#   let(:not_admin){FactoryBot.create :user}
#   let(:invalid_params){{name: ""}}

#   describe "before action" do
#     before{sign_in admin}

#     it {is_expected.to use_before_action :authenticate_user!}
#     it {is_expected.to use_before_action :find_product}
#     it {is_expected.to use_before_action :sub_cat}
#     it {is_expected.to use_before_action :set_locale}
#   end

#   describe "GET #index" do
#     context "when user not signed in" do
#       before{get :index}

#       it{expect(response).to redirect_to new_user_session_path locale: ""}
#     end

#     context "when user signed in but not an admin" do
#       before do
#         sign_in not_admin
#         get :index
#       end

#       it{is_expected.to set_flash[:danger].to(I18n.t "helpers.error[not_admin]")}
#     end

#     context "when user signed in as an admin" do
#       before do
#         sign_in admin
#         get :index
#       end

#       it{expect(response).to render_template :index}
#     end
#   end

#   describe "GET #new" do
#     context "when user did not sign in" do
#       before{get :new}

#       it{expect(response).to redirect_to new_user_session_path locale: ""}
#     end

#     context "when user signed in but is not an admin" do
#       before do
#         sign_in not_admin
#         get :new
#       end

#       it{is_expected.to set_flash[:danger].to(I18n.t "helpers.error[not_admin]")}
#     end

#     context "when user signed in as an admin" do
#       before do
#         sign_in admin
#         get :new
#       end

#       it{expect(response).to render_template :new}
#     end
#   end

#   describe "POST #create" do
#     before {sign_in admin}

#     context "when valid attributes" do
#       it do
#         post :create, params: {product: FactoryBot.attributes_for(:product)}
#         expect(assigns(:product)).to be_a Product
#         expect(flash[:success]).to eql I18n.t "helpers.success[added_product]"
#         expect(response).to redirect_to admin_products_path
#       end
#     end

#     context "when invalid attributes" do
#       it do
#         post :create, params: {product: invalid_params}
#         expect(response).to render_template :new
#       end
#     end
#   end

#   describe "GET #edit" do
#     context "when user did not sign in" do
#       before{get :edit, params:{id: product.id}}

#       it{expect(response).to redirect_to new_user_session_path locale: ""}
#     end

#     context "when user signed in but is not an admin" do
#       before do
#         sign_in not_admin
#         get :edit, params:{id: product.id}
#       end

#       it{is_expected.to set_flash[:danger].to(I18n.t "helpers.error[not_admin]")}
#     end

#     context "when user signed in as an admin" do
#       before do
#         sign_in admin
#         get :edit, params:{id: product.id}
#       end

#       it{expect(response).to render_template :edit}
#     end
#   end

#   describe "PATCH #update" do
#     before {sign_in admin}

#     context "when valid attributes" do
#       it do
#         patch :update, params: {product: FactoryBot.attributes_for(:product), id: product.id}
#         expect(assigns(:product)).to be_a Product
#         expect(flash[:success]).to eql I18n.t "helpers.success[update_product]"
#         expect(response).to redirect_to admin_products_path
#       end
#     end

#     context "when invalid attributes" do
#       it do
#         put :update, params: {product: invalid_params, id: product.id}
#         expect(response).to render_template :edit
#       end
#     end
#   end

#   describe "DELETE #destroy" do
#     before {sign_in admin}

#     it "delete product successful" do
#       delete :destroy, params: {id: product.id}
#       expect(flash[:success]).to eql I18n.t "helpers.success[deleted_product]"
#       expect(response).to redirect_to admin_products_path
#     end
#   end
# end
