require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'associations' do
    it { should belong_to(:expense) }
    it { should belong_to(:user) }
  end
end
