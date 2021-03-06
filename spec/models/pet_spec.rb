require 'rails_helper'

describe Pet, type: :model do
  before :each do
    shelter_1 = Shelter.create!(
      name:     "House of Seamus",
      address:  "6303 W Exposition Ave",
      city:     "Lakewood",
      state:    "CO",
      zip:      "80226"
    )

    @pet_1 = shelter_1.pets.create!(
      image:            "string",
      name:             "Seamus",
      approximate_age:  8,
      sex:              "M",
      description:      "Winter is Coming, dog"
    )

    @pet_2 = shelter_1.pets.create(
      image:            "https://www.catster.com/wp-content/uploads/2018/03/Calico-cat.jpg",
      name:             "Miso",
      approximate_age:  2,
      sex:              "female",
      description:      "Winter is Coming; cat"
    )
  end

  describe "validations" do
    it {should validate_presence_of :image}
    it {should validate_presence_of :name}
    it {should validate_presence_of :approximate_age}
    it {should validate_presence_of :sex}
    it {should validate_presence_of :description}
    # it {should validate_inclusion_of(:adoptable).in_array([true, false])}

    it {should validate_numericality_of :approximate_age}
  end

  describe "relationships" do
    it {should belong_to :shelter}
    it {should have_many :pet_applications}
    it {should have_many(:applications).through(:pet_applications)}
  end

  describe "instance method" do
    it ".shelter_name" do
      expect(@pet_1.shelter_name).to eq "House of Seamus"
    end

    it ".adoptable? initially returns adoptable" do
      expect(@pet_1.adoptable?).to eq true
    end

    it ".toggle_adoptable" do
      @pet_1.toggle_adoptable
      expect(@pet_1.adoptable?).to eq false
    end

    it ".applicant_name" do
      app_1 = create(:application)
      app_2 = create(:application)

      app_1.pets << @pet_1
      app_2.pets << @pet_1
      app_1.pet_applications.first.update(pending: true)
      expect(@pet_1.applicant_name).to eq app_1.name
    end

    it ".applicant_id" do
      application_1 = create(:application)
      application_2 = create(:application)
      application_1.pets << @pet_1
      application_2.pets << @pet_1
      application_1.pet_applications.first.update(pending: true)

      expect(@pet_1.applicant_id).to eq(application_1.id)
    end

    it ".pending_adoption?" do
      app = create(:application)
      app.pets << @pet_1
      app.pet_applications.first.update(pending: true)

      expect(@pet_1.pending_adoption?).to eq true
    end

    it ".find_application" do
      app = create(:application)
      app.pets << @pet_1

      expect(@pet_1.find_application(app.id)).to eq app.pet_applications.first
    end
  end

  describe "class method" do
    it ".sort_adoptable" do
      expect(Pet.all).to match_array [@pet_1, @pet_2]
      @pet_1.adoptable = false
      expect(Pet.sort_adoptable).to match_array [@pet_2, @pet_1]
    end

    it ".all_with_applications" do
      pet_1 = create(:random_pet)
      pet_2 = create(:random_pet)
      application_1 = create(:application)
      application_2 = create(:application)

      application_1.pets << [pet_1, pet_2]
      application_2.pets << [pet_1, pet_2]

      expect(Pet.all_with_applications.length).to eq(2)
      expect(Pet.all_with_applications.include?(pet_1)).to eq(true)
      expect(Pet.all_with_applications.include?(pet_2)).to eq(true)
    end

    it ".all_with_pending_application" do
      pets = create_list(:random_pet, 3)
      app = create(:application)
      app.pets << [pets[0], pets[1]]
      pets[0].update(adoptable: false)
      pets[1].update(adoptable: false)
      pets[0].pet_applications.first.update(pending: true)
      pets[1].pet_applications.first.update(pending: true)

      expect(Pet.all_with_pending_application).to include pets[0]
      expect(Pet.all_with_pending_application).to include pets[1]
      expect(Pet.all_with_pending_application).not_to include pets[2]
    end
  end
end
