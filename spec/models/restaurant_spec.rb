require 'rails_helper'

describe Restaurant, type: :model do
  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "Kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    user = User.create(email: "test@test.com", password: "testtest")
    user.restaurants.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe 'reviews' do
    describe 'build_with_user' do

      let(:user) { User.create email: 'test@test.com' }
      let(:restaurant) { Restaurant.create name: 'Test' }
      let(:review_params) { {rating:5, thoughts: 'yum'} }

      subject(:review) { restaurant.reviews.build_with_user(review_params, user)}

      it 'builds a review' do
        expect(review).to be_a Review
      end

      it 'builds a review associated with the specified user' do
        expect(review.user).to eq user
      end
    end
  end

  describe '#average rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
        let(:user) { User.create email: 'test@test.com', password: "123456"}
        let(:restaurant) { user.restaurants.create name: 'The Ivy'}
        let(:review_params) { {rating:4, thoughts: 'yum'} }

        subject(:review) { restaurant.reviews.create_with_user(review_params, user)}

      it 'returns that rating' do
        review
        expect(restaurant.average_rating).to eq 4
      end
    end
  end
end
