RSpec.feature "Donations", type: :feature do
  before :each do
    sign_in @user
    @url_prefix = "/#{@organization.short_name}"
  end

  context "When visiting the index page" do
    before(:each) do
      visit @url_prefix + "/donations"
    end

    scenario "User can click to the new donation form" do
      click_link "New Donation"

      expect(current_path).to eq(new_donation_path(@organization))
      expect(page).to have_content "Start a new donation"
    end
  end

  context "When building a new donation" do
    before(:each) do
      create(:item)
      create(:dropoff_location)
      create(:storage_location)
      visit @url_prefix + "/donations/new"

      select DropoffLocation.first.name, from: "donation_dropoff_location_id"
      select StorageLocation.first.name, from: "donation_storage_location_id"
      select Donation::SOURCES.first, from: "donation_source"
      select Item.alphabetized.first.name, from: "donation_line_items_attributes_0_item_id"
      fill_in "donation_line_items_attributes_0_quantity", with: "5"
    end

    scenario "User can fill out the form to create a new donation" do
      expect { click_button "Create Donation" }.to change{ Donation.count }.by(1)
    end

    scenario "The inventory at the given storage location increases by item quantity" do
      click_button "Create Donation"
      expect { click_button "Create Donation" }.to change{ StorageLocation.first.inventory_items.count }.by(1)
    end
  end

  context "When working with a new donation" do
    scenario "a user can create a donation" do
      skip
      click_link_or_button "Create Donation"
      expect(current_path).to eq donations_path(organization_id: @organization)
      expect(page.find('.flash')).to have_content('ompleted')
    end
  end

  context "when adding things via barcode" do
    before :each do
      # create one pre-existing barcode associated with an item
      @existing_barcode = create(:barcode_item)
      @item_with_barcode = @existing_barcode.item
      # create a new item that has no barcode existing for it yet
      @item_no_barcode = create(:item)
    end

    scenario "a user can add items via scanning them in by barcode" do
      # enter the barcode into the barcode field
      # the form should update
      pending("TODO: adding items via an existing barcode")
      raise
    end

    scenario "a user can add items that do not yet have a barcode" do
      # enter a new barcode
      # form finds no barcode and responds by prompting user to choose an item and quantity
      # fill that in
      # saves new barcode
      # form updates
      pending "TODO: adding items with a new barcode"
      raise
    end

    scenario "a user can complete a donation" do
      pending "TODO: user can complete a donation with barcodes"
      click_link "Complete Donation"
      expect(current_path).to eq donations_path(organization_id: @organization)
      expect(page.find('.flash')).to have_content('completed')
    end

    context "when adding things via barcode" do
      before :each do
        # create one pre-existing barcode associated with an item
        @existing_barcode = create(:barcode_item)
        @item_with_barcode = @existing_barcode.item
        # create a new item that has no barcode existing for it yet
        @item_no_barcode = create(:item)
      end

      scenario "a user can add items via scanning them in by barcode" do
        # enter the barcode into the barcode field
        # the form should update
        pending("TODO: adding items via an existing barcode")
        raise
      end

      scenario "a user can add items that do not yet have a barcode" do
        # enter a new barcode
        # form finds no barcode and responds by prompting user to choose an item and quantity
        # fill that in
        # saves new barcode
        # form updates
        pending "TODO: adding items with a new barcode"
        raise
      end
    end
  end
end
