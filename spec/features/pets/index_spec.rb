require 'rails_helper'

describe "As a user, when I visit the pet index page," do
  before :each do
    shelters = create_list(:random_shelter, 2)

    @pet_1 = create(:random_pet, shelter: shelters[0])
    @pet_2 = create(:random_pet, shelter: shelters[1])

    visit "/pets"
  end

  it "I can see all pets and their image, name, age, sex, name of shelter" do
    within "#pet-#{@pet_1.id}" do
      expect(page).to have_css "img[src = '#{@pet_1.image}']"
      expect(page).to have_content @pet_1.name
      expect(page).to have_content @pet_1.approximate_age
      expect(page).to have_content @pet_1.sex
      expect(page).to have_content @pet_1.shelter.name
    end
    
    within "#pet-#{@pet_2.id}" do
      expect(page).to have_css "img[src = '#{@pet_2.image}']"
      expect(page).to have_content @pet_2.name
      expect(page).to have_content @pet_2.approximate_age
      expect(page).to have_content @pet_2.sex
      expect(page).to have_content @pet_2.shelter.name
    end
  end

  it "I can navigate to pet update page" do
    within "#pet-#{@pet_1.id}" do
      click_link "Update"
    end
    expect(current_path).to eq "/pets/#{@pet_1.id}/edit"
  end

  it "I can delete a pet" do
    within "#pet-#{@pet_1.id}" do
      click_link "Delete"
    end
    expect(current_path).to_not have_content "Seamus"
  end

  it "I can navigate to a shelter on the page" do
    within "#pet-#{@pet_1.id}" do
      click_link "#{@pet_1.shelter.name}"
    end
    expect(current_path).to eq "/shelters/#{@pet_1.shelter_id}"
  end

  it "can navigate to a pet on the page" do
    within "#pet-#{@pet_1.id}" do
      click_link "#{@pet_1.name}"
    end
    expect(current_path).to eq "/pets/#{@pet_1.id}"
  end

  it "I can see the pets by adoptable status" do
    expect(page.body.index(@pet_1.name)).to be < page.body.index(@pet_2.name)
    visit "/pets/#{@pet_1.id}"
    click_link "Change to Adoption Pending"
    visit "/pets"
    expect(page.body.index(@pet_2.name)).to be < page.body.index(@pet_1.name)
  end
end
