require 'rails_helper'

describe "As a visitor, when I visit /shelters/:id," do
  before :each do
    @shelter_1  = create(:random_shelter)
    @pet        = create(:random_pet, shelter: @shelter_1)
    @reviews    = create_list(:random_shelter_review, 3, shelter: @shelter_1)

    visit "shelters/#{@shelter_1.id}"
  end

  it "I can see the shelter with that id including the shelter's name, address, city, state, zip" do
    expect(page).to have_content @shelter_1.name
    expect(page).to have_content @shelter_1.address
    expect(page).to have_content @shelter_1.city
    expect(page).to have_content @shelter_1.state
    expect(page).to have_content @shelter_1.zip
  end

  it "I can navigate to the edit shelter page via an Update link" do
    click_link "Update"
    expect(current_path).to eq "/shelters/#{@shelter_1.id}/edit"
  end

  it "I can delete the shelter and redirect to index via a link" do
    click_link "Delete"
    expect(current_path).to eq "/shelters"
    expect(page).not_to have_content @shelter_1.name
    expect(page).not_to have_content @shelter_1.address
    expect(page).not_to have_content @shelter_1.city
    expect(page).not_to have_content @shelter_1.state
    expect(page).not_to have_content @shelter_1.zip
  end

  it "I can navigate to the pet index for that shelter" do
    click_link "#{@shelter_1.name}"
    expect(current_path).to eq "/shelters/#{@shelter_1.id}/pets"
  end

  it "I can create a new shelter review" do
    click_link "Add a Review"

    expect(current_path).to eq("/shelters/#{shelter_1.id}/shelter_reviews/new")
    expect(page).to have_content("Add a Review")

    review_title = "Best shelter ever!"
    review_rating = 5
    review_content = "Adopted the best puppy! Only got bit once!"
    review_picture = "https://images.unsplash.com/photo-1506917728037-b6af01a7d403?ixlib=rb-1.2.1&auto=format&fit=crop&w=1934&q=80"

    fill_in "Title", with: review_title
    fill_in "Rating", with: review_rating
    fill_in "Content", with: review_content
    fill_in "Picture", with: review_picture

    click_button "Submit Review"

    expect(current_path).to eq("/shelters/#{shelter_1.id}")

    expect(page).to have_content(review_title)
    expect(page).to have_content(review_rating)
    expect(page).to have_content(review_content)
    expect(page).to have_css("img[src = '#{review_picture}']")
  end

  it "I can see all shelter reviews and their traits" do
    @reviews  = create_list(:random_shelter_review, 3, shelter: @shelter_1)

    visit "/shelters/#{@shelter_1.id}"

    @reviews.each do |review|
      within "#review-#{review.id}" do
        expect(page).to have_content review.title
        expect(page).to have_content review.rating
        expect(page).to have_content review.content
        expect(page).to have_css "img[src = '#{review.picture}']"
      end
    end
  end

  it "has a link to edit a review" do
    within "#review-#{@reviews[0].id}" do
      click_link "Edit Review"

      expect(current_path).to eq "/shelters/#{@shelter_1.id}/shelter_reviews/#{@reviews[0].id}/edit"
    end
  end

  it "has a link to delete each review" do
    within "#review-#{@reviews[0].id}" do
      click_link "Delete Review"
    end

      expect(current_path).to eq "/shelters/#{@shelter_1.id}"
      expect(page).not_to have_content(@reviews[0].title)
      expect(page).not_to have_content(@reviews[0].content)
      expect(page).not_to have_content(@reviews[0].picture)
  end
end
