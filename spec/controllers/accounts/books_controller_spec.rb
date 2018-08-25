require 'rails_helper'

describe Accounts::BooksController do
  before do
    @book = FactoryBot.create(:book)
    account = FactoryBot.create(:account)
    allow(controller).to receive(:current_account).and_return(account)
    allow(controller).to receive(:current_user).and_return(nil)
  end
  
  it "post-receive hooks" do
    expect(Book).to receive(:find_by).and_return(@book)
    expect(@book).to receive(:enqueue)
    post :receive, params: { id: @book.permalink }
  end
end
